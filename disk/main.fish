#!/usr/bin/env fish

set ROOT (type -q git && git rev-parse --show-toplevel 2>/dev/null || pwd)
set DIR (dirname (status --current-filename))

source "$ROOT/common/log.fish"

source "$DIR/detect.fish"
source "$DIR/luks.fish"
source "$DIR/mkdisk.fish"
source "$DIR/partition.fish"

# Picks a disk and prepares it for base system installation.
function main
  log_info "Detecting disk for installation."
  if ! set -l disk (detect_disk)
    log_err "Failed to detect disk to use."
    return 1
  end

  log_info "Partitioning $disk."
  if ! partition $disk
    log_err "Failed to partition $disk."
    return 1
  end

  set -l efi (get_partition $disk 1)
  set -l root (get_partition $disk 2)

  log_info "Encrypting $root."
  if ! encrypt $root $LUKS_PASS
    log_err "Failed to create LUKS partition: $root."
    return 1
  end

  log_info "Attaching encrypted $root."
  if ! set -l mapper (attach $root $LUKS_LABEL $LUKS_PASS)
    log_err "Failed to attach LUKS partition: $root."
    return 1
  end

  log_info "Formatting boot partition: $efi."
  if ! mkefi $efi
    log_err "Failed to create boot partition: $efi."
    return 1
  end

  log_info "Formatting root partition: $mapper."
  if ! mkbtrfs $mapper $MOUNT_OPTS $BTRFS_SUBVOLS /mnt
    log_err "Failed to create root partition: $mapper."
    return 1
  end

  log_info "Mounting all partitions for system installation."
  if ! mount_parts $efi $mapper $BTRFS_SUBVOLS $MOUNT_OPTS /mnt
    log_err "Failed to mount partition for system installation."
    return 1
  end
end

main $argv
