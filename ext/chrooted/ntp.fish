function cfg_ntp -a repo
  xbps_install $repo openntpd || return 1
  ln -s /etc/sv/openntpd /var/service/
end
