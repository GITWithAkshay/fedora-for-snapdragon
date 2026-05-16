# Problem: aria2 retry failed when the existing ISO file was locked

## Exact error

```text
05/16 23:02:02 [ERROR] CUID#7 - Download aborted.
URI=https://download.fedoraproject.org/pub/fedora/linux/releases/44/Workstation/aarch64/iso/Fedora-Workstation-Live-44-1.7.aarch64.iso
Exception: [AbstractCommand.cc:403] errorCode=15
URI=https://mirror.twds.com.tw/fedora/fedora/linux/releases/44/Workstation/aarch64/iso/Fedora-Workstation-Live-44-1.7.aarch64.iso
  -> [RequestGroup.cc:761] errorCode=15 Download aborted.
  -> [AbstractDiskWriter.cc:204] errNum=32 errorCode=15 Failed to open
     the file
     C:/Users/GITWi/OneDrive/Documents/New project/downloads/Fedora-Workstation-Live-44-1.7.aarch64.iso,
     cause: The process cannot access the file because it is being used
     by another process.

aria2 download failed with exit code 15.
```

## Reproduction steps

1. Keep the already downloaded Fedora ISO present under `downloads/`.
2. Mount or otherwise leave the ISO file open in Windows.
3. Run
   `powershell -ExecutionPolicy Bypass -File .\scripts\download-fedora-iso.ps1`.
4. Observe `aria2` try to reopen the target file and fail with a file-lock
   error before checksum verification can run.

## Environment

- OS: Windows on ARM
- Shell: PowerShell
- Download tool: `aria2`
- File:
  `downloads\Fedora-Workstation-Live-44-1.7.aarch64.iso`

## First hypothesis

The downloader should verify an existing ISO before invoking `aria2`, so a
mounted or otherwise locked completed file can still pass validation without
triggering a write attempt.
