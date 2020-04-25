function install_extended -a repo -a mnt -a cron -a ntp -a slog
  if test $cron = yes
    xbps_install $repo -r $mnt cronie || return 1
  end

  if test $ntp = yes
    xbps_install $repo -r $mnt openntpd || return 1
  end

  if test $slog = yes
    xbps_install $repo -r $mnt socklog-void || return 1
  end
end
