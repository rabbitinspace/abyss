set ROOT (git rev-parse --show-toplevel || pwd)
set DIR (dirname (status --current-filename))

source "$ROOT/common/log.fish"

source "$DIR/detect.fish"
source "$DIR/luks.fish"
source "$DIR/mkdisk.fish"
source "$DIR/partition.fish"

# Picks a disk and prepares it for base system installation.
function prepare_disk
  if ! set -l disk (detect_disk)
    log_err "Failed to detect disk to use."
    return 1
  end

  if ! partition $disk
    log_err "Failed to partition $disk."
    return 1
  end

  set -l efi (get_partition $disk 1)
  set -l root (get_partition $disk 2)

  if ! encrypt $root $LUKS_PASSWORD
    log_err "Failed to create LUKS partition: $root."
    return 1
  end

  if ! set -l mapper (attach $root $LUKS_LABEL $LUKS_PASSWORD)
    log_err "Failed to attach LUKS partition: $root."
    return 1
  end

  if ! mkefi $efi
    log_err "Failed to create boot partition: $efi."
    return 1
  end

  if ! mkbtrfs $mapper $MOUNT_OPTS $BTRFS_SUBVOLS
    log_err "Failed to create root partition: $mapper."
    return 1
  end

  if ! mount_parts $efi $mapper $BTRFS_SUBVOLS $MOUNT_OPTS
    log_err "Failed to mount partition for system installation."
    return 1
  end
end
