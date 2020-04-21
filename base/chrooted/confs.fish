function cfg_root -a pass
  chown root:root /
  chmod 755 /
  echo "root:$pass" | chpasswd -c SHA512
end

function cfg_confs -a hostname -a lang -a locales
  echo $hostname > /etc/hostname
  echo "LANG=$lang" > /etc/locale.conf
  for locale in (string split ',' $locales)
    echo "locale" >> /etc/default/libc-locales
  end

  xbps-reconfigure -f glibc-locales
end
