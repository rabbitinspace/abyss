# Generates and installs a new key to autodecrypt a partition at boot.
#
# This is needed to precent typing decryption password twice on boot. The key
# will be generated using /dev/urandom and stored in /boot directory.
#
# Args:
#   $part - path to the partition to automatically decrypt.
#   $pass - partition decription password.
#   $key - name of the key to generate.
function autodecrypt -a part -a pass -a key
  dd bs=512 count=4 \
    if=/dev/urandom \
    of="/mnt/boot/$key" \
    status=none || return 1

  echo $pass \
    | cryptsetup luksAddKey \
    $part "/mnt/boot/$key" -d \
    >&2 - || return 1

  chmod 000 "/mnt/boot/$key"
  chmod -R g-rwx,o-rwx /mnt/boot
end
