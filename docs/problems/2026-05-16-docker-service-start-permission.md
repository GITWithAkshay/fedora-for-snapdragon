# Problem: Docker Desktop service could not be started directly from PowerShell

## Exact error

<!-- markdownlint-disable MD013 -->
```text
Start-Service: Service 'Docker Desktop Service (com.docker.service)' cannot be started due to the following error: Cannot open 'com.docker.service' service on computer '.'.
```
<!-- markdownlint-enable MD013 -->

## Reproduction steps

1. Open PowerShell in the repository root without elevated privileges.
2. Run `Start-Service com.docker.service`.
3. Observe Windows deny access to the Docker Desktop service control.

## Environment

- OS: Windows on ARM
- Service: `com.docker.service`
- Shell: PowerShell

## First hypothesis

The Docker Desktop Windows service requires elevated service-control access,
so a non-elevated shell cannot start it directly even though the desktop app
can still be launched in user space.
