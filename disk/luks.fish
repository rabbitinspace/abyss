# Encrypts disk partition.
#
# The partition will be encrypted via dm-crypt using aes-xts-plain64 cipher
# with 512 byets key size (256 for each key part) and sha512 hash.
# The format used is LUKS1.
#
# Args:
#   $part - path to the partition to encrypt.
#   $pass - password that will be used to decrypt the partition.
#   $align - sector alignment.
function encrypt -a part -a pass -a align
  echo -n $pass \
    | cryptsetup \
    --type luks1 \
    --cipher aes-xts-plain64 \
    --key-slot 1 \
    --key-size 512 \
    --hash sha512 \
    --align-payload $align \
    luksFormat $part \
    >&2
end

# Decrypts encrypted partition and prints it's path.
#
# Args:
#   $part - path to the encrypted partition.
#   $name - name to use for the decrypted partition.
#   $pass - decryption password.
function attach -a part -a name -a pass
  echo -n $pass \
    | cryptsetup \
    luksOpen $part $name \
    >&2 || return 1

  if test $status -ne 0
    return $status
  end

  # print name of the mapped disk
  echo "/dev/mapper/$name"
end
