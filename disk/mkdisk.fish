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
  mkfs.btrfs -s 4096 $part >&2

  set -l mnt /mnt
  mount -o $opts $part $mnt
  for vol in $vols
    btrfs subvolume create "$mnt"/@$vol >&2
  end

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
  for vol in $vols
    mkdir -p "$mnt"/$vol
    mount -o subvol=@$vol,$opts $root "$mnt"/$vol
  end

  # second, mount boot partition
  mkdir -p "$mnt"/boot/efi
  mount $efi "$mnt"/boot/efi

  # finally, create additional subvolumes to disable cow
  __create_nested_subvols $mnt
end

# Creates additional subvolumes for directories where CoW is not needed.
function __create_nested_subvols -a mnt
  mkdir -p "$mnt"/var/cache
  btrfs subvolume create "$mnt"/var/cache/xbps >&2
  btrfs subvolume create "$mnt"/var/tmp >&2
  btrfs subvolume create "$mnt"/srv >&2
end
