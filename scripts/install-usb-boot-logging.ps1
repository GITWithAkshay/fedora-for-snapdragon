param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern("^[A-Za-z]$")]
    [string]$UsbDriveLetter
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function New-Directory {
    param([string]$Path)

    New-Item -ItemType Directory -Path $Path -Force | Out-Null
}

function Set-FileWritable {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return
    }

    & attrib -R -S -H $Path
    $item = Get-Item -LiteralPath $Path
    if ($item.PSObject.Properties.Name -contains "IsReadOnly") {
        $item.IsReadOnly = $false
    }
}

function New-ArchiveFromDirectory {
    param(
        [string]$SourceDirectory,
        [string]$ArchivePath
    )

    if (Test-Path $ArchivePath) {
        Remove-Item -LiteralPath $ArchivePath -Force
    }

    Push-Location $SourceDirectory
    try {
        & tar --zstd --format cpio -cf $ArchivePath .
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to create archive $ArchivePath."
        }
    }
    finally {
        Pop-Location
    }
}

function Get-GrubKernelArguments {
    param([string]$GrubConfigPath)

    $content = Get-Content $GrubConfigPath
    foreach ($line in $content) {
        if ($line -match '^\s*linux \(\$root\)/boot/aarch64/loader/linux-book4edge\s+(.+)$') {
            return @{ Patched = $Matches[1] }
        }
    }

    throw "Could not find the patched Book4 Edge kernel arguments in $GrubConfigPath."
}

function New-DiagnosticsGrubBlock {
    param([string]$PatchedArgs)

    $diagnosticArgs = "$PatchedArgs rd.debug rd.live.debug log_buf_len=4M ignore_loglevel systemd.log_level=debug systemd.log_target=console rd.udev.log_level=debug plymouth.enable=0 systemd.show_status=1"
    $template = @'
# BEGIN BOOK4 EDGE DIAGNOSTICS
menuentry "Start Fedora-Workstation-Live (Book4 Edge 14 diagnostics)" {
        linux ($root)/boot/aarch64/loader/linux-book4edge __DIAG_ARGS__
        devicetree ($root)/boot/dtb/qcom/x1e80100-samsung-galaxy-book4-edge-14.dtb
        initrd ($root)/boot/aarch64/loader/initrd
}

menuentry "Start Fedora-Workstation-Live (Book4 Edge 16 diagnostics)" {
        linux ($root)/boot/aarch64/loader/linux-book4edge __DIAG_ARGS__
        devicetree ($root)/boot/dtb/qcom/x1e84100-samsung-galaxy-book4-edge-16.dtb
        initrd ($root)/boot/aarch64/loader/initrd
}
# END BOOK4 EDGE DIAGNOSTICS
'@

    return $template.Replace("__DIAG_ARGS__", $diagnosticArgs)
}

$normalizedDriveLetter = $UsbDriveLetter.ToUpperInvariant()
$usbRoot = "$normalizedDriveLetter`:"
$initrdPath = Join-Path $usbRoot "boot\aarch64\loader\initrd"
$initrdBackupPath = Join-Path $usbRoot "boot\aarch64\loader\initrd.book4edge-backup"
$grubConfigPath = Join-Path $usbRoot "boot\grub2\grub.cfg"
$logsRoot = Join-Path $usbRoot "book4edge-logs"
$workRoot = Join-Path $usbRoot "book4edge-initrd-addon"
$overlayRoot = Join-Path $workRoot "overlay"
$hookPath = Join-Path $overlayRoot "lib\dracut\hooks\pre-pivot\95-book4edge-boot-logs.sh"
$addonArchivePath = Join-Path $workRoot "book4edge-initrd-addon.cpio.zst"
$tempPatchedInitrdPath = Join-Path $workRoot "initrd.with-book4edge-logging"

foreach ($requiredPath in @($usbRoot, $initrdPath, $grubConfigPath)) {
    if (-not (Test-Path $requiredPath)) {
        throw "Required USB path not found: $requiredPath"
    }
}

if (Test-Path $workRoot) {
    Remove-Item -LiteralPath $workRoot -Recurse -Force
}

New-Directory -Path (Split-Path -Parent $hookPath)
New-Directory -Path $logsRoot

if (-not (Test-Path $initrdBackupPath)) {
    Copy-Item -LiteralPath $initrdPath -Destination $initrdBackupPath -Force
}

$hookContent = @'
#!/usr/bin/sh
LOGROOT="$NEWROOT/var/lib/book4edge-logs/initrd"
mkdir -p "$LOGROOT" "$NEWROOT/usr/local/sbin" "$NEWROOT/etc/systemd/system/multi-user.target.wants"

{
    echo "timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || true)"
    echo "cmdline=$(cat /proc/cmdline 2>/dev/null || true)"
    echo "newroot=$NEWROOT"
} > "$LOGROOT/meta.txt"

dmesg > "$LOGROOT/initrd-dmesg.txt" 2>&1 || true
journalctl -b --no-pager > "$LOGROOT/initrd-journal.txt" 2>&1 || true
cp -a /run/initramfs/rdsosreport.txt "$LOGROOT/" 2>/dev/null || true

cat > "$NEWROOT/usr/local/sbin/book4edge-save-live-logs.sh" <<'EOF'
#!/usr/bin/sh
set -eu

TARGET_BASE="/var/lib/book4edge-logs"
LIVE_LABEL=""
for arg in $(cat /proc/cmdline); do
    case "$arg" in
        root=live:LABEL=*) LIVE_LABEL="${arg#root=live:LABEL=}" ;;
        root=live:CDLABEL=*) LIVE_LABEL="${arg#root=live:CDLABEL=}" ;;
    esac
done
[ -n "$LIVE_LABEL" ] || LIVE_LABEL="Eshank"

STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
MNT="/run/book4edge-log-usb"
OUTROOT=""
MOUNTED_HERE=0

mkdir -p "$MNT"
if mount "/dev/disk/by-label/$LIVE_LABEL" "$MNT" 2>/dev/null; then
    MOUNTED_HERE=1
fi

for candidate in "$MNT" /run/initramfs/live "/run/media/liveuser/$LIVE_LABEL"; do
    [ -d "$candidate" ] || continue
    if mkdir -p "$candidate/book4edge-logs/$STAMP" 2>/dev/null; then
        OUTROOT="$candidate/book4edge-logs/$STAMP"
        break
    fi
done

[ -n "$OUTROOT" ] || exit 0

cp -a "$TARGET_BASE/initrd" "$OUTROOT/" 2>/dev/null || true
journalctl -b --no-pager > "$OUTROOT/journalctl-b.txt" 2>&1 || true
dmesg > "$OUTROOT/dmesg.txt" 2>&1 || true
systemctl --failed --no-pager > "$OUTROOT/failed-units.txt" 2>&1 || true
uname -a > "$OUTROOT/uname-a.txt" 2>&1 || true
cat /proc/cmdline > "$OUTROOT/proc-cmdline.txt" 2>&1 || true
lsblk -f > "$OUTROOT/lsblk-f.txt" 2>&1 || true
lsmod > "$OUTROOT/lsmod.txt" 2>&1 || true
cp /run/initramfs/rdsosreport.txt "$OUTROOT/" 2>/dev/null || true
sync || true

if [ "$MOUNTED_HERE" = "1" ]; then
    umount "$MNT" 2>/dev/null || true
fi
EOF

chmod +x "$NEWROOT/usr/local/sbin/book4edge-save-live-logs.sh"

cat > "$NEWROOT/etc/systemd/system/book4edge-save-live-logs.service" <<'EOF'
[Unit]
Description=Save Book4 Edge live boot logs to USB
After=multi-user.target systemd-journald.service local-fs.target
Wants=local-fs.target
ConditionPathExists=/var/lib/book4edge-logs/initrd

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/book4edge-save-live-logs.sh

[Install]
WantedBy=multi-user.target
EOF

ln -sf ../book4edge-save-live-logs.service "$NEWROOT/etc/systemd/system/multi-user.target.wants/book4edge-save-live-logs.service"
'@

[System.IO.File]::WriteAllText($hookPath, $hookContent, [System.Text.UTF8Encoding]::new($false))
New-ArchiveFromDirectory -SourceDirectory $overlayRoot -ArchivePath $addonArchivePath

Copy-Item -LiteralPath $initrdBackupPath -Destination $tempPatchedInitrdPath -Force
Set-FileWritable -Path $tempPatchedInitrdPath
$baseBytes = [System.IO.File]::ReadAllBytes($tempPatchedInitrdPath)
$addonBytes = [System.IO.File]::ReadAllBytes($addonArchivePath)
$combined = New-Object byte[] ($baseBytes.Length + $addonBytes.Length)
[System.Buffer]::BlockCopy($baseBytes, 0, $combined, 0, $baseBytes.Length)
[System.Buffer]::BlockCopy($addonBytes, 0, $combined, $baseBytes.Length, $addonBytes.Length)
[System.IO.File]::WriteAllBytes($tempPatchedInitrdPath, $combined)

Set-FileWritable -Path $initrdPath
Copy-Item -LiteralPath $tempPatchedInitrdPath -Destination $initrdPath -Force

Set-FileWritable -Path $grubConfigPath
$grubArgs = Get-GrubKernelArguments -GrubConfigPath $grubConfigPath
$currentGrub = Get-Content $grubConfigPath -Raw

if ($currentGrub -notmatch '# BEGIN BOOK4 EDGE DIAGNOSTICS') {
    $diagBlock = New-DiagnosticsGrubBlock -PatchedArgs $grubArgs.Patched
    $patchedGrub = $diagBlock.TrimEnd() + "`r`n`r`n" + $currentGrub.TrimStart()
    [System.IO.File]::WriteAllText($grubConfigPath, $patchedGrub, [System.Text.UTF8Encoding]::new($false))
}

Remove-Item -LiteralPath $workRoot -Recurse -Force

Write-Host "Installed Book4 Edge boot logging onto $usbRoot"
Write-Host "Log destination prepared at $logsRoot"
Write-Host "Initrd backup at $initrdBackupPath"
