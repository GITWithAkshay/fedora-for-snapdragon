param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern("^[A-Za-z]$")]
    [string]$UsbDriveLetter
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$driveRoot = "$($UsbDriveLetter.ToUpperInvariant()):"
$logsRoot = Join-Path $driveRoot "book4edge-logs"

if (-not (Test-Path -LiteralPath $driveRoot)) {
    throw "USB drive not found at $driveRoot"
}

if (-not (Test-Path -LiteralPath $logsRoot)) {
    throw "Log root not found at $logsRoot"
}

$attempts = Get-ChildItem -LiteralPath $logsRoot -Directory -ErrorAction Stop |
    Sort-Object LastWriteTime -Descending

if (-not $attempts) {
    Write-Warning "No boot-attempt folders were found under $logsRoot yet."
    exit 1
}

$latest = $attempts | Select-Object -First 1

$expectedFiles = @(
    "journalctl-b.txt",
    "dmesg.txt",
    "failed-units.txt",
    "lsblk-f.txt",
    "lsmod.txt",
    "proc-cmdline.txt",
    "uname-a.txt"
)

$presentFiles = foreach ($name in $expectedFiles) {
    $path = Join-Path $latest.FullName $name
    [pscustomobject]@{
        Name = $name
        Present = (Test-Path -LiteralPath $path)
    }
}

Write-Host "Latest boot-attempt logs: $($latest.FullName)"
Write-Host ""
Write-Host "Expected files:"
$presentFiles | Format-Table Name, Present -AutoSize
Write-Host ""

$failedUnitsPath = Join-Path $latest.FullName "failed-units.txt"
$cmdlinePath = Join-Path $latest.FullName "proc-cmdline.txt"
$unamePath = Join-Path $latest.FullName "uname-a.txt"

if (Test-Path -LiteralPath $unamePath) {
    Write-Host "uname -a:"
    Get-Content -LiteralPath $unamePath | Select-Object -First 3
    Write-Host ""
}

if (Test-Path -LiteralPath $cmdlinePath) {
    Write-Host "/proc/cmdline:"
    Get-Content -LiteralPath $cmdlinePath | Select-Object -First 2
    Write-Host ""
}

if (Test-Path -LiteralPath $failedUnitsPath) {
    Write-Host "Failed units summary:"
    Get-Content -LiteralPath $failedUnitsPath | Select-Object -First 40
    Write-Host ""
}

$initrdDir = Join-Path $latest.FullName "initrd"
if (Test-Path -LiteralPath $initrdDir) {
    Write-Host "Initrd log files:"
    Get-ChildItem -LiteralPath $initrdDir -File | Select-Object Name, Length | Format-Table -AutoSize
    Write-Host ""
}

Write-Host "To inspect the full log bundle:"
Write-Host "  $($latest.FullName)"
