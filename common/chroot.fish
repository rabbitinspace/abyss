# Runs a script while being chrooted into another root.
#
# Args:
#   $mnt - path to directory to chroot into.
#   $path - path to the directory with the 'main.fish' script to run.
#   $base - path to the bootscraap directory.
function run_chrooted -a mnt -a path -a base
  __bind_sys $mnt || return 1
  __copy_path "$mnt/chrooted" $path $base || return 1

  chroot $mnt /bin/fish "/chrooted/main.fish" || return 1
  rm -rf "$mnt/chrooted"
  __unbind_sys $mnt
end

# Binds necessary devices and directories into the system.
#
# Args:
#   $mnt - mount point of the system.
function __bind_sys -a mnt
  for dir in dev proc sys run
    mkdir -p "$mnt/$dir"
    mount --rbind /$dir "$mnt/$dir" || return 1
    mount --make-rslave "$mnt/$dir" || return 1
  end
end

# Unbnids everything that was bound by the __bind_sys function.
#
# Args:
#   $mnt - mount point of the system.
function __unbind_sys -a mnt
  for dir in dev proc sys run
    umount -R "$mnt/$dir"
  end
end

# Copied scripts to run while being chrooted.
#
# Args:
#   $mnt - mount point where to copy bootstrap scripts.
#   $path - path to directory to copy.
#   $base - path to the bootscraap directory.
function __copy_path -a mnt -a path -a base
  mkdir -p $mnt
  cp -R "$path/." $mnt
  cp "$base/config.fish" $mnt
  cp -R "$base/common" $mnt
end
