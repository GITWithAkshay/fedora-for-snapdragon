param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern("^[A-Za-z]$")]
    [string]$UsbDriveLetter,
    [string]$StageDirectory = ""
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

$RepoRoot = Split-Path -Parent $PSScriptRoot

if ([string]::IsNullOrWhiteSpace($StageDirectory)) {
    $resolvedStageDirectory = Join-Path $env:TEMP "fedora-workstation-live-book4edge"
}
else {
    $resolvedStageDirectory = Resolve-RepoPath $StageDirectory
}
$normalizedDriveLetter = $UsbDriveLetter.ToUpperInvariant()
$usbRoot = "$normalizedDriveLetter`:"

if (-not (Test-Path $resolvedStageDirectory)) {
    throw "Stage directory not found: $resolvedStageDirectory"
}

if (-not (Test-Path $usbRoot)) {
    throw "USB drive not found at $usbRoot"
}

if ($normalizedDriveLetter -eq $env:SystemDrive.TrimEnd(':').ToUpperInvariant()) {
    throw "Refusing to mirror onto the Windows system drive."
}

Invoke-RobocopyMirror -SourcePath $resolvedStageDirectory -DestinationPath $usbRoot

Write-Host "Synced patched Fedora staging tree to USB drive $usbRoot"
