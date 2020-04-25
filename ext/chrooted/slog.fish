function cfg_slog -a repo
  ln -s /etc/sv/socklog-unix /var/service/
  ln -s /etc/sv/nanoklogd /var/service/
end
