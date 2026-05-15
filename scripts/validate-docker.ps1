Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$imageName = "galaxy-book4-edge-fedora-builder:0.1.4"
$requiredArtifacts = @(
    "build-output/Image.gz",
    "build-output/x1e80100-samsung-galaxy-book4-edge-14.dtb",
    "build-output/x1e84100-samsung-galaxy-book4-edge-16.dtb",
    "build-output/galaxy-book4-edge-v6.patch"
)

function Invoke-DockerChecked {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    & docker @Arguments | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker command failed: docker $($Arguments -join ' ')"
    }
}

Invoke-DockerChecked -Arguments @("version")
Invoke-DockerChecked -Arguments @("image", "inspect", $imageName)

foreach ($artifact in $requiredArtifacts) {
    if (-not (Test-Path $artifact)) {
        throw "Required artifact missing: $artifact"
    }
}

Write-Host "Docker validation completed successfully."
