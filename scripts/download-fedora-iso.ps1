param(
    [string]$IsoUrl = "https://download.fedoraproject.org/pub/fedora/linux/releases/44/Workstation/aarch64/iso/Fedora-Workstation-Live-44-1.7.aarch64.iso",
    [string]$OutputName = "Fedora-Workstation-Live-44-1.7.aarch64.iso",
    [string]$ExpectedSha256 = "162ba3c552a2d241c7c63ec26777af0255ee1b5a135adc0be986ceed999933ef",
    [string]$DownloadDirectory = "downloads"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-Aria2Executable {
    $command = Get-Command aria2c -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    $wingetRoots = @(
        (Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages"),
        (Join-Path $env:ProgramFiles "WindowsApps")
    )

    foreach ($root in $wingetRoots) {
        if (-not (Test-Path $root)) {
            continue
        }

        $match = Get-ChildItem -Path $root -Filter aria2c.exe -Recurse -File `
            -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($match) {
            return $match.FullName
        }
    }

    throw "aria2c.exe was not found in PATH or common winget install locations."
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$targetDirectory = Join-Path $repoRoot $DownloadDirectory
New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null

$aria2c = Get-Aria2Executable
$destination = Join-Path $targetDirectory $OutputName

Write-Host "Using aria2 executable: $aria2c"
Write-Host "Downloading ISO to: $destination"

if (-not (Test-Path $destination)) {
    & $aria2c `
        --dir=$targetDirectory `
        --out=$OutputName `
        --continue=true `
        --max-connection-per-server=8 `
        --split=8 `
        --min-split-size=10M `
        --retry-wait=5 `
        --max-tries=10 `
        $IsoUrl

    if ($LASTEXITCODE -ne 0) {
        throw "aria2 download failed with exit code $LASTEXITCODE."
    }
}

if (-not (Test-Path $destination)) {
    throw "The expected ISO file was not created at $destination."
}

$hash = (Get-FileHash -Path $destination -Algorithm SHA256).Hash.ToLowerInvariant()

if ($hash -ne $ExpectedSha256.ToLowerInvariant()) {
    Write-Host "Existing ISO hash did not match the expected Fedora release hash."
    Write-Host "Retrying the download with aria2 so the file can be resumed or replaced."

    & $aria2c `
        --dir=$targetDirectory `
        --out=$OutputName `
        --continue=true `
        --allow-overwrite=true `
        --max-connection-per-server=8 `
        --split=8 `
        --min-split-size=10M `
        --retry-wait=5 `
        --max-tries=10 `
        $IsoUrl

    if ($LASTEXITCODE -ne 0) {
        throw "aria2 download failed with exit code $LASTEXITCODE."
    }

    $hash = (Get-FileHash -Path $destination -Algorithm SHA256).Hash.ToLowerInvariant()
}

if ($hash -ne $ExpectedSha256.ToLowerInvariant()) {
    throw "SHA256 mismatch for $destination. Expected $ExpectedSha256 but got $hash."
}

Write-Host "Verified SHA256: $hash"
Write-Host "Fedora ISO download completed successfully."
