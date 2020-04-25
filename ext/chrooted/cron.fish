function cfg_cron -a repo
  xbps_install $repo cronie || return 1
  ln -s /etc/sv/cronie /var/service/
end
