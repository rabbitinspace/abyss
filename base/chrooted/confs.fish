# Configures root user.
#
# Args:
#   $pass - root password.
function set_root -a pass
  chown root:root /
  chmod 755 /
  echo "root:$pass" | chpasswd -c SHA512
end

# Sets hostname.
# Args:
#   name - well, it's hostname.
function set_hostname -a name
  echo $naem > /etc/hostname
end

# Configures system language and enabled locales.
#
# Args:
#   $lang - system language to set.
#   $locales - comma-separated list of locales to enable.
function cfg_locale -a lang -a locales
  # set language
  echo "LANG=$lang.UTF-8" > /etc/locale.conf
  echo "LC_TIME=$lang.UTF-8"

  # enable locales
  for locale in (string split ',' $locales)
    echo "locale.UTF-8 UTF-8" >> /etc/default/libc-locales
  end

  xbps-reconfigure -f glibc-locales
end
