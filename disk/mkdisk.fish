# Formats given partition to a suitable EFI file system.
#
# Args:
#   $part - path to the partition to format.
function mkefi -a part
  mkfs.vfat -F32 $part >&2
end

# Formats given partition to Btrfs and creates nessesary subvolumes.
#
# Args:
#   $part - path to the partition to format.
#   $opts - mount options to use for subvolume creation.
#   $vols - list of subvolumes to create.
function mkbtrfs -a part -a opts -a vols
  # first, create fs
  mkfs.btrfs -s 4096 $part >&2 || return 1

  # and mount it
  set -l mnt /mnt
  mount -o $opts $part $mnt || return 1

  # second, create subvolumes
  for vol in (string split ',' $vols)
    btrfs subvolume create "$mnt/@$vol" >&2 || return 1
  end

  # finally, unmount everything
  umount -R $mnt
end

# Mounts partitions for base system installation.
#
# Args:
#   $efi - path to EFI partition.
#   $root - path to root Btrfs partition.
#   $vols - list of Btrfs subvolumes to mount.
#   $opts - mount options for the rool partition.
function mount_parts -a efi -a root -a vols -a opts
  set -l mnt /mnt

  # first, mount root partition and it's subvolumes
  for vol in (string split ',' $vols)
    mkdir -p "$mnt/$vol"
    mount -o subvol=@$vol,$opts $root "$mnt/$vol" || return 1
  end

  # second, mount boot partition
  mkdir -p "$mnt/boot/efi" || return 1
  mount $efi "$mnt/boot/efi" || return 1

  # finally, create additional subvolumes
  __create_nested_subvols $mnt || return 1
end

# Creates additional subvolumes for directories where CoW is not needed.
function __create_nested_subvols -a mnt
  mkdir -p "$mnt/var/cache"
  for vol in var/cache/xbps var/tmp srv
    btrfs subvolume create "$mnt/$vol" >&2 || return 1
  end
end
