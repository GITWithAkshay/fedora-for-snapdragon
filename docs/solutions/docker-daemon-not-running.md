# Solution: start Docker Desktop and wait for the Linux engine

Related problem:
[docs/problems/2026-05-16-docker-daemon-not-running.md](../problems/2026-05-16-docker-daemon-not-running.md)

## What failed

The Docker client was installed, but `docker version` could not reach the
`desktop-linux` engine pipe.

## What worked

Started Docker Desktop from the user session and waited until
`docker version` reported both client and server details.

## Why it worked

Docker Desktop brought up the Linux engine even though the Windows service
was not directly controllable from the non-elevated shell.

## All commands run

<!-- markdownlint-disable MD013 -->
```text
docker version
Start-Process -FilePath "C:\Program Files\Docker\Docker\Docker Desktop.exe" -WindowStyle Hidden
docker version
docker info
```
<!-- markdownlint-enable MD013 -->
