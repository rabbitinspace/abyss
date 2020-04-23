# Configures root user.
#
# Args:
#   $pass - root password.
function cfg_root -a pass
  chown root:root /
  chmod 755 /
  echo "root:$pass" | chpasswd -c SHA512
end

# Sets hostname.
# Args:
#   name - well, it's hostname.
function cfg_hostname -a name
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
    echo "$locale.UTF-8 UTF-8" >> /etc/default/libc-locales
  end
end

# Configures rc.conf.
#
# Args:
#   $hwc - hardware clock standard.
#   $tz - local timezone.
#   $km - keymap to load.
function cfg_rcconf -a hwc -a tz -a km
  set -l path /etc/rc.conf

  sed -i "/HARDWARECLOCK/d" $path && echo "HARDWARECLOCK=\"$hwc\"" >> $path
  sed -i "/TIMEZONE/d" $path && echo "TIMEZONE=\"$tz\"" >> $path
  sed -i "/KEYMAP/d" $path && echo "KEYMAP=\"$km\"" >> $path

  ln -sf "/usr/share/zoneinfo/$tz" /etc/localtime
end

# Configures dracut.
#
# Args:
#   $mods - comma-separated list of modules to load.
function cfg_dracut -a mods
  echo 'add_dracutmodules+="crypt btrfs resume"' >> /etc/dracut.conf
  echo 'tmpdir=/tmp' >> /etc/dracut.conf

  if set -l key (cat /etc/crypttab | grep -Po '/boot/[^\s]+')
    mkdir -p /etc/dracut.conf.d/
    echo "install_items+=\"$key /etc/crypttab\"" > /etc/dracut.conf.d/11-crypt.conf
  end

  if test -n "$mods"
    mkdir -p /etc/dracut.conf.d/
    set -l lmods (echo $mods | string split , | string join " ")
    echo "add_dracutmodules+=\"$lmods\"" > /etc/dracut.conf.d/99-addmod.conf
  end
end

# Reconfigures locales, bootloader and initramfs.
function recfg_all
  set -l kver (ls /usr/lib/modules | xargs -L 1 basename) || return 1
  set -l kmm (echo $kver | string split '.' | head -n 2 | string join '.')

  xbps-reconfigure -f glibc-locales || return 1
  dracut --force --kver $kver || return 1
  grub-mkconfig -o /boot/grub/grub.cfg || return 1
  grub-install \
    --target=x86_64-efi \
    --efi-directory=/boot/efi \
    --bootloader-id=void \
    --boot-directory=/boot \
    --recheck || return 1

  xbps-reconfigure -f "linux$kmm"
end
