# Performs final system setup.
#
# Args:
#   $mnt - mount point of the system.
#   $self_path - path to the bootstrap directory.
function bootstrap_chrooted -a mnt -a self_path
  __bind_sys $mnt
  __copy_self "$mnt/chrooted" $self_path

  chroot $mnt /bin/fish "/chrooted/main.fish"
  rm -rf "$mnt/chrooted"
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

# Copies bootstrap scripts into the system.
#
# Args:
#   $mnt - mount point where to copy bootstrap scripts.
#   $self_path - path to the bootstrap directory.
function __copy_self -a mnt -a self_path
  mkdir -p $mnt
  cp -R "$self_path/chrooted/." $mnt
  cp "$self_path/config.fish" $mnt
  cp "$self_path/common/log.fish" $mnt
end
