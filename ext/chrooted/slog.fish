function cfg_slog -a repo
  ln -sf /etc/sv/socklog-unix /var/service/
  ln -sf /etc/sv/nanoklogd /var/service/
end
