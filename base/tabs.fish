# Generates /etc/fstab.
#
# Fstab will be generated from currently mounted filesystems.
#
# Args:
#   $rpath - path to resources directory.
#   $mnt - mount point from where to generate fstab.
function gen_fstab -a rpath -a mnt
  "$rpath/genfstab" -U $mnt >> "$mnt/etc/fstab"
end

# Generates /etc/crypttab.
#
# Generates crypttab file to automaticaly decrypt root partition with a keyfile.
# Note, 'discard' mount option will be added added to enable TRIM on SSDs.
#
# Args:
#   $label - root partition label.
#   $key - path to decryption key.
function gen_crypttab -a label -a key -a mnt
  set -l line (blkid | grep "PARTLABEL=\"$label\"" | grep LUKS) || return 1
  set -l uuid (
    echo $line \
      | grep -Po '\sUUID=\"[\d\w\-]+\"' \
      | grep -Po '[\d\w\-]+' \
      | tail -n1
  ) || return 1

  echo "$label    UUID=$uuid    /boot/$key    luks,discard" >> "$mnt/etc/crypttab"
end
