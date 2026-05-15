# Problem: Docker client could not reach the Linux engine

## Exact error

<!-- markdownlint-disable MD013 -->
```text
Client:
 Version:           29.2.1
 API version:       1.53
 Go version:        go1.25.6
 Git commit:        a5c7197
 Built:             Mon Feb  2 18:17:39 2026
 OS/Arch:           windows/arm64
Context:           desktop-linux
failed to connect to the docker API at npipe:////./pipe/dockerDesktopLinuxEngine; check if the path is correct and if the daemon is running: open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified.
```
<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Open a PowerShell prompt in the repository root.
2. Run `docker version`.
3. Observe the client report its version and then fail to connect to the
   Linux engine named by the `desktop-linux` context.

## Environment

- OS: Windows on ARM
- Docker client: `29.2.1`
- Docker context: `desktop-linux`
- Repository path: `C:\Users\GITWi\OneDrive\Documents\New project`

## First hypothesis

Docker Desktop is installed but the Linux engine process has not started
yet, so the named pipe for the daemon is missing.
