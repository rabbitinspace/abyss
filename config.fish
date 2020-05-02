#
# LUKS
#

# disk's sector alignment
set LUKS_ALIGN 4096

# disk encryption password
set LUKS_PASS SUPER_STRONG_PASSWORD

# name of the key to prevent entering decryption password twice
set LUKS_KEY volume.key

# label for the decrypted root partition
set LUKS_LABEL void

#
# DRIVES
#

# mount options for the root partition (remove ssd if not needed)
set MOUNT_OPTS rw,noatime,nodiratime,ssd,compress=zstd,space_cache

# top-level btrfs subvolumes to create (starts with ',' and no 'boot')
set BTRFS_SUBVOLS ,home,snapshots

#
# SYSTEM
#

# machine's hostname
set HOSTNAME abyss

# change this if time isn't stored as UTC
set HARDWARECLOCK UTC

# your timezone
set TIMEZONE Australia/Sydney

# default keymap to load
set KEYMAP us

# system language
set LANG en_US

# comma-separated list of locales
set LOCALES en_US

# comma-separated list of modules to load
set DRACUT_MODS drm

#
# XBPS
#

# url for the packages repo (default is https://alpha.de.repo.voidlinux.org/current)
set XBPS_REPO https://ftp.swin.edu.au/voidlinux/current

#
# USERS
#

# name of the default user
set USER_NAME SUPER_USER

# password of the default user
set USER_PASS SUPER_STRONG_PASSWORD

# comma-separated list of groups to add the user to
set USER_GROUPS wheel,users,audio,video,input

# login shell for the user
set USER_SHELL /bin/bash

#
# EXTENDED SETUP
#

# set to no to disable extended configuration
set EXT_SETUP yes

# install cron daemon (set to no to disable)
set EXT_CRON yes

# install dhcp daemon (set to no to disable)
set EXT_DHCP yes

# install ntp daemon (set to no to disable)
set EXT_NTP yes

# install syslog daemon (set to no to disable)
set EXT_SLOG yes

# enable firewall (set to no to disable)
set EXT_FIREWALL yes

# install syscctl rules for kernel hardening (set to no to disable)
set EXT_SYS_RULES yes

# enable weekly fstrim invocations (set no to disable)
# -- disable it if you don't have ssd or if your ssd doesn't support TRIM --
set EXT_TRIM yes
