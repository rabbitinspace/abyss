# Generates /etc/fstab.
#
# Fstab will be generated from currently mounted filesystems.
#
# Args:
#   $rpath - path to resources directory.
function gen_fstab -a rpath
  "$rpath/genfstab" -U /mnt >> /mnt/etc/fstab
end

# Generates /etc/crypttab.
#
# Generates crypttab file to automaticaly decrypt root partition with a keyfile.
# Note, 'discard' mount option will be added added to enable TRIM on SSDs.
#
# Args:
#   $label - root partition label.
#   $key - path to decryption key.
function gen_crypttab -a label -a key
  set -l line (blkid | grep "PARTLABEL=\"$label\"" | grep LUKS) || return 1
  set -l uuid (
    echo $line \
      | grep -Po '\sUUID=\"[\d\w\-]+\"' \
      | grep -Po '[\d\w\-]+' \
      | tail -n1
  ) || return 1

  echo "$label    UUID=$uuid    $key    luks,discard" >> /mnt/etc
end
