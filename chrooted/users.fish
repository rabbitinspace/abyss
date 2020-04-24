# Configures default user.
#
# Args:
#   $name - username of the default user.
#   $pass - password for the user.
#   $groups - groups to add the user to.
#   $shell - path to a login shell for the user.
function cfg_user -a name -a pass -a groups -a shell
  useradd -m -G $groups -s $shell $name
  echo "$name:$pass" | chpasswd -c SHA512

  echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
  passwd -ld root
end
