param(
    [string]$IsoPath = "downloads/Fedora-Workstation-Live-44-1.7.aarch64.iso",
    [string]$KernelImageGzPath = "build-output/Image.gz",
    [string]$Dtb14Path = "build-output/x1e80100-samsung-galaxy-book4-edge-14.dtb",
    [string]$Dtb16Path = "build-output/x1e84100-samsung-galaxy-book4-edge-16.dtb",
    [string]$StageDirectory = "",
    [switch]$Force
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

    @"
# BEGIN BOOK4 EDGE PATCHED ENTRIES
menuentry "Start Fedora-Workstation-Live (Book4 Edge 14 patched)" {
        linux (\$root)/boot/aarch64/loader/linux-book4edge $StandardArgs
        devicetree (\$root)/boot/dtb/qcom/x1e80100-samsung-galaxy-book4-edge-14.dtb
        initrd (\$root)/boot/aarch64/loader/initrd
}

menuentry "Start Fedora-Workstation-Live (Book4 Edge 16 patched)" {
        linux (\$root)/boot/aarch64/loader/linux-book4edge $StandardArgs
        devicetree (\$root)/boot/dtb/qcom/x1e84100-samsung-galaxy-book4-edge-16.dtb
        initrd (\$root)/boot/aarch64/loader/initrd
}

menuentry "Start Fedora-Workstation-Live (Book4 Edge 14 patched, basic graphics)" {
        linux (\$root)/boot/aarch64/loader/linux-book4edge $BasicArgs
        devicetree (\$root)/boot/dtb/qcom/x1e80100-samsung-galaxy-book4-edge-14.dtb
        initrd (\$root)/boot/aarch64/loader/initrd
}

menuentry "Start Fedora-Workstation-Live (Book4 Edge 16 patched, basic graphics)" {
        linux (\$root)/boot/aarch64/loader/linux-book4edge $BasicArgs
        devicetree (\$root)/boot/dtb/qcom/x1e84100-samsung-galaxy-book4-edge-16.dtb
        initrd (\$root)/boot/aarch64/loader/initrd
}
# END BOOK4 EDGE PATCHED ENTRIES
"@
}

$RepoRoot = Split-Path -Parent $PSScriptRoot
$resolvedIsoPath = Resolve-RepoPath $IsoPath
$resolvedKernelImageGzPath = Resolve-RepoPath $KernelImageGzPath
$resolvedDtb14Path = Resolve-RepoPath $Dtb14Path
$resolvedDtb16Path = Resolve-RepoPath $Dtb16Path

if ([string]::IsNullOrWhiteSpace($StageDirectory)) {
    $resolvedStageDirectory = Join-Path $env:TEMP "fedora-workstation-live-book4edge"
}
else {
    $resolvedStageDirectory = Resolve-RepoPath $StageDirectory
}

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

if (Test-Path $resolvedStageDirectory) {
    if (-not $Force) {
        throw "Stage directory already exists. Re-run with -Force to recreate $resolvedStageDirectory."
    }

    Remove-Item -LiteralPath $resolvedStageDirectory -Recurse -Force
}

New-Item -ItemType Directory -Path $resolvedStageDirectory -Force | Out-Null

$mountedHere = $false
$isoDriveLetter = $null

try {
    $diskImage = Get-DiskImage -ImagePath $resolvedIsoPath -ErrorAction SilentlyContinue

    if (-not $diskImage -or -not $diskImage.Attached) {
        $diskImage = Mount-DiskImage -ImagePath $resolvedIsoPath -PassThru
        $mountedHere = $true
    }

    $volume = $diskImage | Get-Volume | Where-Object { $_.DriveLetter } | Select-Object -First 1
    if (-not $volume) {
        throw "Could not resolve a mounted drive letter for $resolvedIsoPath."
    }

    $isoDriveLetter = $volume.DriveLetter
    $isoRoot = "$isoDriveLetter`:"

    Invoke-RobocopyMirror -SourcePath $isoRoot -DestinationPath $resolvedStageDirectory

    $loaderDirectory = Join-Path $resolvedStageDirectory "boot\aarch64\loader"
    $dtbDirectory = Join-Path $resolvedStageDirectory "boot\dtb\qcom"
    $patchedKernelPath = Join-Path $loaderDirectory "linux-book4edge"
    $grubConfigPath = Join-Path $resolvedStageDirectory "boot\grub2\grub.cfg"

    New-Item -ItemType Directory -Path $dtbDirectory -Force | Out-Null

    Expand-GzipFile -SourcePath $resolvedKernelImageGzPath -DestinationPath $patchedKernelPath
    Copy-Item -LiteralPath $resolvedDtb14Path -Destination (Join-Path $dtbDirectory (Split-Path $resolvedDtb14Path -Leaf)) -Force
    Copy-Item -LiteralPath $resolvedDtb16Path -Destination (Join-Path $dtbDirectory (Split-Path $resolvedDtb16Path -Leaf)) -Force

    $grubArgs = Get-GrubKernelArguments -GrubConfigPath $grubConfigPath
    $originalGrub = Get-Content $grubConfigPath -Raw
    $customBlock = New-CustomGrubBlock -StandardArgs $grubArgs.Standard -BasicArgs $grubArgs.Basic

    if ($originalGrub -notmatch '# BEGIN BOOK4 EDGE PATCHED ENTRIES') {
        $patchedGrub = $customBlock.TrimEnd() + "`r`n`r`n" + $originalGrub.TrimStart()
        [System.IO.File]::WriteAllText($grubConfigPath, $patchedGrub, [System.Text.UTF8Encoding]::new($false))
    }

    Write-Host "Prepared patched Fedora staging tree at: $resolvedStageDirectory"
    Write-Host "Mounted ISO source: $isoRoot"
    Write-Host "Injected kernel: $patchedKernelPath"
}
finally {
    if ($mountedHere) {
        Dismount-DiskImage -ImagePath $resolvedIsoPath
    }
}
