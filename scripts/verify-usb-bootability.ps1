param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern("^[A-Za-z]$")]
    [string]$UsbDriveLetter
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-UsbDiskContext {
    param([string]$DriveLetter)

    $logicalDriveId = "$($DriveLetter.ToUpperInvariant()):"
    $logicalDisk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$logicalDriveId'"
    if (-not $logicalDisk) {
        throw "Drive $logicalDriveId was not found."
    }

    $mapping = Get-CimInstance Win32_LogicalDiskToPartition |
        Where-Object { $_.Dependent -match [regex]::Escape($logicalDriveId) } |
        Select-Object -First 1

    if (-not $mapping) {
        throw "Could not map $logicalDriveId to a disk partition."
    }

    $partitionId = ([regex]::Match($mapping.Antecedent, 'DeviceID = "(.+)"')).Groups[1].Value
    $partition = Get-CimInstance Win32_DiskPartition |
        Where-Object { $_.DeviceID -eq $partitionId } |
        Select-Object -First 1

    if (-not $partition) {
        throw "Could not resolve the partition for $logicalDriveId."
    }

    $disk = Get-CimInstance Win32_DiskDrive |
        Where-Object { $_.Index -eq $partition.DiskIndex } |
        Select-Object -First 1

    if (-not $disk) {
        throw "Could not resolve the parent disk for $logicalDriveId."
    }

    return @{
        LogicalDisk = $logicalDisk
        Partition = $partition
        PartitionInfo = (Get-Partition -DiskNumber $partition.DiskIndex -PartitionNumber ($partition.Index + 1))
        Disk = $disk
        DriveRoot = "$($DriveLetter.ToUpperInvariant()):"
    }
}

function Test-PathItem {
    param([string]$Path)

    return Test-Path -LiteralPath $Path
}

$context = Get-UsbDiskContext -DriveLetter $UsbDriveLetter
$logicalDisk = $context.LogicalDisk
$partition = $context.Partition
$partitionInfo = $context.PartitionInfo
$disk = $context.Disk
$driveRoot = $context.DriveRoot

$checks = @(
    [pscustomobject]@{
        Check = "USB disk mapping"
        Expected = "InterfaceType = USB"
        Actual = $disk.InterfaceType
        Passed = ($disk.InterfaceType -eq "USB")
    }
    [pscustomobject]@{
        Check = "Removable drive type"
        Expected = "DriveType = 2"
        Actual = $logicalDisk.DriveType
        Passed = ($logicalDisk.DriveType -eq 2)
    }
    [pscustomobject]@{
        Check = "Filesystem"
        Expected = "FAT32"
        Actual = $logicalDisk.FileSystem
        Passed = ($logicalDisk.FileSystem -eq "FAT32")
    }
    [pscustomobject]@{
        Check = "EFI removable boot file"
        Expected = "EFI\\BOOT\\BOOTAA64.EFI exists"
        Actual = (Join-Path $driveRoot "EFI\\BOOT\\BOOTAA64.EFI")
        Passed = (Test-PathItem (Join-Path $driveRoot "EFI\\BOOT\\BOOTAA64.EFI"))
    }
    [pscustomobject]@{
        Check = "Patched kernel"
        Expected = "boot\\aarch64\\loader\\linux-book4edge exists"
        Actual = (Join-Path $driveRoot "boot\\aarch64\\loader\\linux-book4edge")
        Passed = (Test-PathItem (Join-Path $driveRoot "boot\\aarch64\\loader\\linux-book4edge"))
    }
    [pscustomobject]@{
        Check = "Patched GRUB config"
        Expected = "boot\\grub2\\grub.cfg contains Book4 Edge entries"
        Actual = (Join-Path $driveRoot "boot\\grub2\\grub.cfg")
        Passed = (
            (Test-PathItem (Join-Path $driveRoot "boot\\grub2\\grub.cfg")) -and
            (Select-String -Path (Join-Path $driveRoot "boot\\grub2\\grub.cfg") -Pattern "Book4 Edge" -Quiet)
        )
    }
)

if ((Get-Disk -Number $disk.Index).PartitionStyle -eq "MBR") {
    $checks += [pscustomobject]@{
        Check = "MBR active flag"
        Expected = "IsActive = True for the boot partition"
        Actual = $partitionInfo.IsActive
        Passed = [bool]$partitionInfo.IsActive
    }
}

$checks | Format-Table Check, Expected, Actual, Passed -AutoSize

$failed = $checks | Where-Object { -not $_.Passed }

Write-Host ""
Write-Host "USB summary:"
Write-Host "  Drive: $driveRoot"
Write-Host "  Label: $($logicalDisk.VolumeName)"
Write-Host "  Filesystem: $($logicalDisk.FileSystem)"
Write-Host "  Disk model: $($disk.Model)"
Write-Host "  Partition type: $($partition.Type)"

if ($failed) {
    Write-Warning "This USB does not currently meet all common UEFI removable-boot checks."
    if ($logicalDisk.FileSystem -ne "FAT32") {
        Write-Warning "The strongest current blocker is the filesystem: many UEFI boot menus will not list an exFAT removable drive."
    }
    elseif ((Get-Disk -Number $disk.Index).PartitionStyle -eq "MBR" -and -not $partitionInfo.IsActive) {
        Write-Warning "The filesystem is now correct, but the MBR boot partition is not marked active."
    }
    exit 1
}

Write-Host "The USB passes the static bootability checks implemented by this script."
