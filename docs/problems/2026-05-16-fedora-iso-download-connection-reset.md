# Problem: Fedora ARM ISO download was interrupted by a remote connection reset

## Exact error

```text
Invoke-WebRequest:
Line |
   2 |  … yContinue'; Invoke-WebRequest
     |  -Uri 'https://download.fedoraproject.or …
     |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     | One or more errors occurred. (Unable to read data from the transport
     | connection: An existing connection was forcibly closed by the remote
     | host..)
```

## Reproduction steps

1. Open PowerShell in the repository root.
2. Create `downloads\` if it does not exist.
3. Run `Invoke-WebRequest` against the Fedora Workstation 44 aarch64 ISO URL
   and write the result to `downloads\Fedora-Workstation-Live-44-1.7.aarch64.iso`.
4. Wait for the transfer to progress for several minutes.
5. Observe the request terminate with a transport-connection reset.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Target URL:
  `https://download.fedoraproject.org/pub/fedora/linux/releases/44/Workstation/aarch64/iso/Fedora-Workstation-Live-44-1.7.aarch64.iso`

## First hypothesis

`Invoke-WebRequest` is not handling this large Fedora mirror transfer
robustly enough in the current network path, so the ISO fetch needs a
download method with stronger resume or retry behavior.
