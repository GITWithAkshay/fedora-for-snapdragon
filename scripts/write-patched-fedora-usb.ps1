param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern("^[A-Za-z]$")]
    [string]$UsbDriveLetter,
    [string]$IsoPath = "downloads/Fedora-Workstation-Live-44-1.7.aarch64.iso",
    [string]$KernelImageGzPath = "build-output/Image.gz",
    [string]$Dtb14Path = "build-output/x1e80100-samsung-galaxy-book4-edge-14.dtb",
    [string]$Dtb16Path = "build-output/x1e84100-samsung-galaxy-book4-edge-16.dtb",
    [string]$UsbVolumeLabel = "FEDORA44",
    [int]$PartitionSizeMB = 8192,
    [switch]$SkipReformat
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-RepoPath {
    param([string]$Path)

    if ([System.IO.Path]::IsPathRooted($Path)) {
        return $Path
    }

    return Join-Path $script:RepoRoot $Path
}

function Expand-GzipFile {
    param(
        [string]$SourcePath,
        [string]$DestinationPath
    )

    $sourceStream = $null
    $gzipStream = $null
    $destinationStream = $null

    try {
        $sourceStream = [System.IO.File]::OpenRead($SourcePath)
        $gzipStream = New-Object System.IO.Compression.GzipStream(
            $sourceStream,
            [System.IO.Compression.CompressionMode]::Decompress
        )
        $destinationStream = [System.IO.File]::Create($DestinationPath)
        $gzipStream.CopyTo($destinationStream)
    }
    finally {
        if ($destinationStream) { $destinationStream.Dispose() }
        if ($gzipStream) { $gzipStream.Dispose() }
        if ($sourceStream) { $sourceStream.Dispose() }
    }
}

function Invoke-RobocopyMirror {
    param(
        [string]$SourcePath,
        [string]$DestinationPath
    )

    & robocopy $SourcePath $DestinationPath /MIR /R:2 /W:2 /NFL /NDL /NJH /NJS /NP
    $exitCodeVar = Get-Variable -Name LASTEXITCODE -ErrorAction SilentlyContinue
    $exitCode = if ($exitCodeVar) { [int]$exitCodeVar.Value } else { 0 }

    if ($exitCode -gt 7) {
        throw "robocopy failed with exit code $exitCode while mirroring $SourcePath to $DestinationPath."
    }
}

function Get-UsbDiskContext {
    param([string]$DriveLetter)

    $logicalDriveId = "$($DriveLetter.ToUpperInvariant()):"
    $logicalDisk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$logicalDriveId'"
    if (-not $logicalDisk) {
        throw "Drive $logicalDriveId was not found."
    }

    $mapping = Get-CimInstance Win32_LogicalDiskToPartition |
        Where-Object { $_.Dependent -match [regex]::Escape($logicalDriveId) } |
        Select-Object -First 1

    if (-not $mapping) {
        throw "Could not map $logicalDriveId to a disk partition."
    }

    $partitionId = ([regex]::Match($mapping.Antecedent, 'DeviceID = "(.+)"')).Groups[1].Value
    $partition = Get-CimInstance Win32_DiskPartition |
        Where-Object { $_.DeviceID -eq $partitionId } |
        Select-Object -First 1

    if (-not $partition) {
        throw "Could not resolve the partition for $logicalDriveId."
    }

    $disk = Get-CimInstance Win32_DiskDrive |
        Where-Object { $_.Index -eq $partition.DiskIndex } |
        Select-Object -First 1

    if (-not $disk) {
        throw "Could not resolve the parent disk for $logicalDriveId."
    }

    return @{
        LogicalDisk = $logicalDisk
        Partition = $partition
        Disk = $disk
    }
}

function Invoke-DiskpartScript {
    param([string[]]$Lines)

    $diskpartScriptPath = Join-Path $env:TEMP ("diskpart-" + [guid]::NewGuid().ToString("N") + ".txt")
    try {
        [System.IO.File]::WriteAllLines($diskpartScriptPath, $Lines, [System.Text.UTF8Encoding]::new($false))
        & diskpart /s $diskpartScriptPath
        $exitCodeVar = Get-Variable -Name LASTEXITCODE -ErrorAction SilentlyContinue
        $exitCode = if ($exitCodeVar) { [int]$exitCodeVar.Value } else { 0 }
        if ($exitCode -ne 0) {
            throw "diskpart failed with exit code $exitCode."
        }
    }
    finally {
        if (Test-Path $diskpartScriptPath) {
            Remove-Item $diskpartScriptPath -Force
        }
    }
}

function Wait-ForDrivePath {
    param([string]$DriveRoot)

    for ($attempt = 0; $attempt -lt 30; $attempt++) {
        if (Test-Path $DriveRoot) {
            return
        }

        Start-Sleep -Seconds 2
    }

    throw "Timed out waiting for drive $DriveRoot to appear after repartitioning."
}

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Set-FileWritable {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return
    }

    & attrib -R -S -H $Path
    $item = Get-Item -LiteralPath $Path
    if ($item.PSObject.Properties.Name -contains "IsReadOnly") {
        $item.IsReadOnly = $false
    }
}

function Get-GrubKernelArguments {
    param([string]$GrubConfigPath)

    $content = Get-Content $GrubConfigPath
    $standardArgs = $null
    $basicArgs = $null

    foreach ($line in $content) {
        if (-not $standardArgs -and $line -match '^\s*linux \(\$root\)/boot/aarch64/loader/linux\s+(.+)$') {
            $standardArgs = $Matches[1]
            continue
        }

        if (-not $basicArgs -and $line -match '^\s*linux \(\$root\)/boot/aarch64/loader/linux\s+(.+\$\{basicgfx\})$') {
            $basicArgs = $Matches[1]
        }
    }

    if (-not $standardArgs) {
        throw "Could not find the Fedora live kernel arguments in $GrubConfigPath."
    }

    if (-not $basicArgs) {
        $basicArgs = "$standardArgs `${basicgfx}"
    }

    return @{
        Standard = $standardArgs
        Basic = $basicArgs
    }
}

function New-CustomGrubBlock {
    param(
        [string]$StandardArgs,
        [string]$BasicArgs
    )

    $template = @'
# BEGIN BOOK4 EDGE PATCHED ENTRIES
menuentry "Start Fedora-Workstation-Live (Book4 Edge 14 patched)" {
        linux ($root)/boot/aarch64/loader/linux-book4edge __STANDARD_ARGS__
        devicetree ($root)/boot/dtb/qcom/x1e80100-samsung-galaxy-book4-edge-14.dtb
        initrd ($root)/boot/aarch64/loader/initrd
}

menuentry "Start Fedora-Workstation-Live (Book4 Edge 16 patched)" {
        linux ($root)/boot/aarch64/loader/linux-book4edge __STANDARD_ARGS__
        devicetree ($root)/boot/dtb/qcom/x1e84100-samsung-galaxy-book4-edge-16.dtb
        initrd ($root)/boot/aarch64/loader/initrd
}

menuentry "Start Fedora-Workstation-Live (Book4 Edge 14 patched, basic graphics)" {
        linux ($root)/boot/aarch64/loader/linux-book4edge __BASIC_ARGS__
        devicetree ($root)/boot/dtb/qcom/x1e80100-samsung-galaxy-book4-edge-14.dtb
        initrd ($root)/boot/aarch64/loader/initrd
}

menuentry "Start Fedora-Workstation-Live (Book4 Edge 16 patched, basic graphics)" {
        linux ($root)/boot/aarch64/loader/linux-book4edge __BASIC_ARGS__
        devicetree ($root)/boot/dtb/qcom/x1e84100-samsung-galaxy-book4-edge-16.dtb
        initrd ($root)/boot/aarch64/loader/initrd
}
# END BOOK4 EDGE PATCHED ENTRIES
'@

    return $template.Replace("__STANDARD_ARGS__", $StandardArgs).Replace("__BASIC_ARGS__", $BasicArgs)
}

$RepoRoot = Split-Path -Parent $PSScriptRoot
$resolvedIsoPath = Resolve-RepoPath $IsoPath
$resolvedKernelImageGzPath = Resolve-RepoPath $KernelImageGzPath
$resolvedDtb14Path = Resolve-RepoPath $Dtb14Path
$resolvedDtb16Path = Resolve-RepoPath $Dtb16Path

foreach ($requiredPath in @(
    $resolvedIsoPath,
    $resolvedKernelImageGzPath,
    $resolvedDtb14Path,
    $resolvedDtb16Path
)) {
    if (-not (Test-Path $requiredPath)) {
        throw "Required input path not found: $requiredPath"
    }
}

$usbContext = Get-UsbDiskContext -DriveLetter $UsbDriveLetter
$disk = $usbContext.Disk
$diskNumber = [int]$disk.Index
$logicalDisk = $usbContext.LogicalDisk

if ($disk.InterfaceType -ne "USB") {
    throw "Refusing to continue because drive $UsbDriveLetter is not backed by a USB disk."
}

if ($diskNumber -eq 0) {
    throw "Refusing to continue because the target disk maps to disk 0."
}

if ($UsbVolumeLabel.Length -gt 11) {
    throw "USB volume label '$UsbVolumeLabel' is too long for FAT32. Use 11 characters or fewer."
}

$normalizedDriveLetter = $UsbDriveLetter.ToUpperInvariant()
$usbRoot = "$normalizedDriveLetter`:"
$mountedHere = $false
$isAdministrator = Test-IsAdministrator
$effectiveLiveLabel = $UsbVolumeLabel

if (-not $isAdministrator -and -not $SkipReformat) {
    $SkipReformat = $true
    Write-Warning "Falling back to in-place USB patching because the current shell is not elevated."
}

if ($SkipReformat) {
    if (-not $logicalDisk.VolumeName) {
        throw "The existing USB volume does not have a label. Set a simple label first or run the writer from an elevated shell."
    }

    if ($logicalDisk.VolumeName -match '\s') {
        throw "The existing USB volume label '$($logicalDisk.VolumeName)' contains whitespace. Use a simple label or run the writer from an elevated shell."
    }

    $effectiveLiveLabel = $logicalDisk.VolumeName
}

try {
    if (-not $SkipReformat) {
        Invoke-DiskpartScript -Lines @(
            "select disk $diskNumber",
            "clean",
            "convert gpt",
            "create partition primary size=$PartitionSizeMB",
            "format fs=fat32 quick label=$UsbVolumeLabel",
            "assign letter=$normalizedDriveLetter",
            "exit"
        )

        Wait-ForDrivePath -DriveRoot $usbRoot
    }

    $diskImage = Get-DiskImage -ImagePath $resolvedIsoPath -ErrorAction SilentlyContinue
    if (-not $diskImage -or -not $diskImage.Attached) {
        $diskImage = Mount-DiskImage -ImagePath $resolvedIsoPath -PassThru
        $mountedHere = $true
    }

    $volume = $diskImage | Get-Volume | Where-Object { $_.DriveLetter } | Select-Object -First 1
    if (-not $volume) {
        throw "Could not resolve a mounted drive letter for $resolvedIsoPath."
    }

    $isoRoot = "$($volume.DriveLetter):"
    Invoke-RobocopyMirror -SourcePath $isoRoot -DestinationPath $usbRoot

    $loaderDirectory = Join-Path $usbRoot "boot\aarch64\loader"
    $dtbDirectory = Join-Path $usbRoot "boot\dtb\qcom"
    $patchedKernelPath = Join-Path $loaderDirectory "linux-book4edge"
    $grubConfigPath = Join-Path $usbRoot "boot\grub2\grub.cfg"

    New-Item -ItemType Directory -Path $dtbDirectory -Force | Out-Null

    Expand-GzipFile -SourcePath $resolvedKernelImageGzPath -DestinationPath $patchedKernelPath
    Copy-Item -LiteralPath $resolvedDtb14Path -Destination (Join-Path $dtbDirectory (Split-Path $resolvedDtb14Path -Leaf)) -Force
    Copy-Item -LiteralPath $resolvedDtb16Path -Destination (Join-Path $dtbDirectory (Split-Path $resolvedDtb16Path -Leaf)) -Force

    Set-FileWritable -Path $grubConfigPath

    $originalGrub = Get-Content $grubConfigPath -Raw
    $updatedGrub = $originalGrub -replace 'root=live:CDLABEL=[^\s]+', "root=live:LABEL=$effectiveLiveLabel"
    $updatedGrub = $updatedGrub -replace 'root=live:LABEL=[^\s]+', "root=live:LABEL=$effectiveLiveLabel"
    [System.IO.File]::WriteAllText($grubConfigPath, $updatedGrub, [System.Text.UTF8Encoding]::new($false))

    $grubArgs = Get-GrubKernelArguments -GrubConfigPath $grubConfigPath
    $customBlock = New-CustomGrubBlock -StandardArgs $grubArgs.Standard -BasicArgs $grubArgs.Basic
    $currentGrub = Get-Content $grubConfigPath -Raw

    if ($currentGrub -notmatch '# BEGIN BOOK4 EDGE PATCHED ENTRIES') {
        $patchedGrub = $customBlock.TrimEnd() + "`r`n`r`n" + $currentGrub.TrimStart()
        [System.IO.File]::WriteAllText($grubConfigPath, $patchedGrub, [System.Text.UTF8Encoding]::new($false))
    }

    Write-Host "Prepared patched Fedora USB on $usbRoot"
    Write-Host "USB disk number: $diskNumber"
    Write-Host "USB live-media label: $effectiveLiveLabel"
    Write-Host "Reformat skipped: $SkipReformat"
}
finally {
    if ($mountedHere) {
        Dismount-DiskImage -ImagePath $resolvedIsoPath
    }
}
