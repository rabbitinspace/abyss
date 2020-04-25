function cfg_slog -a repo
  xbps_install $repo socklog-void || return 1
  ln -s /etc/sv/socklog-unix /var/service/
  ln -s /etc/sv/nanoklogd /var/service/
end
