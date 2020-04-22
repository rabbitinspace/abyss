# Generates and installs a new key to autodecrypt a partition at boot.
#
# This is needed to precent typing decryption password twice on boot. The key
# will be generated using /dev/urandom and stored in /boot directory.
#
# Args:
#   $label - label of the LUKS partition.
#   $pass - partition decription password.
#   $key - name of the key to generate.
#   $mnt - mount point where to install key.
function autodecrypt -a label -a pass -a key -a mnt
  set -l line (blkid | grep "PARTLABEL=\"$label\"" | grep LUKS) || return 1
  set -l part (echo $line | cut -d ':' -f 1)

  dd bs=512 count=4 \
    if=/dev/urandom \
    of="$mnt/boot/$key" \
    status=none || return 1

  echo $pass \
    | cryptsetup luksAddKey \
    $part "$mnt/boot/$key" -d \
    >&2 - || return 1

  chmod 000 "$mnt/boot/$key"
  chmod -R g-rwx,o-rwx "$mnt/boot"
end

# Sets default GRUB configuration.
#
# Args:
#   $label - label of the root LUKS partition.
#   $mnt - mount point of the decrypted LUKS partition.
function set_grub_defaults -a label -a mnt
  # get uuid of the LUKS partition
  set -l line (blkid | grep "PARTLABEL=\"$label\"" | grep LUKS) || return 1
  set -l uuid (
    echo $line \
      | grep -Po '\sUUID=\"[\d\w\-]+\"' \
      | grep -Po '[\d\w\-]+' \
      | tail -n1
  ) || return 1

  # grub options we need to be able to boot from encrypted btrfs partition
  set -l opts "GRUB_CMDLINE_LINUX=\"rootflags=subvol=@ rd.auto=1 \
    rd.luks.allow-discards cryptdevice=UUID=$uuid:$label\""

  # backup original config and remove options that we're gonna change
  set -l path "$mnt/etc/default/grub"
  cp $path "$path.backup"
  sed -i "/GRUB_CMDLINE_LINUX/d" $path
  sed -i "/GRUB_ENABLE_CRYPTODISK/d" $path

  # write our options
  echo "GRUB_ENABLE_CRYPTODISK=y" >> $path
  echo $opts >> $path
end
