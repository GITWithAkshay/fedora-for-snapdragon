$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$venvPath = Join-Path $repoRoot ".venv-windows"

function Invoke-Checked {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,
        [string[]]$Arguments = @()
    )

    & $FilePath @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Command failed: $FilePath $($Arguments -join ' ')"
    }
}

if (-not (Test-Path $venvPath)) {
    Invoke-Checked "python" @("-m", "venv", $venvPath)
}

$pythonExe = Join-Path $venvPath "Scripts\\python.exe"

Invoke-Checked $pythonExe @("-m", "pip", "install", "--upgrade", "pip")
Invoke-Checked $pythonExe @(
    "-m",
    "pip",
    "install",
    "-r",
    (Join-Path $repoRoot "requirements-dev.txt")
)
Invoke-Checked "npm" @("install")
Invoke-Checked $pythonExe @("-m", "pre_commit", "install")
Invoke-Checked $pythonExe @("-m", "pre_commit", "run", "--all-files")
Invoke-Checked "npm" @("run", "lint:md")

Write-Host "Windows development environment is ready."
