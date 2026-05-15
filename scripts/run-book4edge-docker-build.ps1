Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$dockerfile = Join-Path $repoRoot "docker/fedora-kernel-builder.Dockerfile"
$imageName = "galaxy-book4-edge-fedora-builder:0.1.3"
$sourceVolume = "galaxy-book4edge-kernel-src"
$outVolume = "galaxy-book4edge-kernel-out"
$desktopExe = "C:\Program Files\Docker\Docker\Docker Desktop.exe"

function Wait-DockerEngine {
    param(
        [int]$TimeoutSeconds = 180
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        try {
            docker version | Out-Null
            return
        } catch {
            Start-Sleep -Seconds 3
        }
    }

    throw "Docker engine did not become ready within $TimeoutSeconds seconds."
}

try {
    docker version | Out-Null
} catch {
    if (-not (Test-Path $desktopExe)) {
        throw "Docker Desktop is not installed at $desktopExe."
    }

    Start-Process -FilePath $desktopExe -WindowStyle Hidden
    Wait-DockerEngine
}

docker build `
    --tag $imageName `
    --file $dockerfile `
    $repoRoot

docker volume create $sourceVolume | Out-Null
docker volume create $outVolume | Out-Null

docker run --rm `
    --mount "type=bind,src=$repoRoot,target=/workspace" `
    --mount "type=volume,src=$sourceVolume,target=/state/src" `
    --mount "type=volume,src=$outVolume,target=/state/out" `
    $imageName `
    bash /workspace/scripts/build-book4edge-docker.sh
