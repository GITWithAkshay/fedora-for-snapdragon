# Solution: use Docker Desktop user-space startup instead of Start-Service

Related problem:
[docs/problems/2026-05-16-docker-service-start-permission.md](../problems/2026-05-16-docker-service-start-permission.md)

## What failed

`Start-Service com.docker.service` was rejected from the non-elevated
PowerShell session.

## What worked

Launched Docker Desktop directly and let the repository launcher wait for
the engine to become ready.

## Why it worked

The desktop app can start the Linux engine in the user session without
requiring direct Windows service control from this shell.

## All commands run

<!-- markdownlint-disable MD013 -->
```text
Start-Service com.docker.service
Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle Hidden
docker version
```
<!-- markdownlint-enable MD013 -->
