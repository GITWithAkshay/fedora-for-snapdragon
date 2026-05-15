param(
    [Parameter(Mandatory = $true)]
    [string]$StepName,
    [Parameter(Mandatory = $true)]
    [string]$Action,
    [Parameter(Mandatory = $true)]
    [string]$Result
)

$logPath = Join-Path (Split-Path -Parent $PSScriptRoot) "docs\\steps.md"
$timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssK"

$lines = @(
    "",
    "## $timestamp",
    "",
    "- Step name: $StepName",
    "- Action: $Action",
    "- Result: $Result"
)

$content = [string]::Join("`n", $lines) + "`n"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$existing = ""

if (Test-Path $logPath) {
    $existing = [System.IO.File]::ReadAllText($logPath)
}

[System.IO.File]::WriteAllText($logPath, $existing + $content, $utf8NoBom)
