set DIR (dirname (status --current-filename))

source "$DIR/detect.fish"
source "$DIR/luks.fish"
source "$DIR/mkdisk.fish"
source "$DIR/partition.fish"

function prepare_disk
  set -l disk (detect_disk || exit 1)
  partition $disk

  set -l efi (get_partition $disk 1 || exit 1)
  set -l root (get_partition $disk 2 || exit 1)
  encrypt $root $LUKS_PASSWORD

  set -l mapper (attach $root $LUKS_LABEL $LUKS_PASSWORD || exit 1)
  mkefi $efi || exit 1
  mkbtrfs $root $MOUNT_OPTS $BTRFS_SUBVOLS || exit 1

  mount_parts $efi $root $BTRFS_SUBVOLS $MOUNT_OPTS || exit 1
end
