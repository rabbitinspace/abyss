# LUKS

set LUKS_ALIGN 4096  # sector alignment
set LUKS_PASS SUPER_STRONG_PASSWORD  # disk encryption password
set LUKS_KEY volume.key  # name of the key to prevent entering decryption password twice
set LUKS_LABEL void  # decrypted root partition label

# DRIVES

set MOUNT_OPTS rw,noatime,nodiratime,ssd,compress=zstd,space_cache  # mount options for the root partition
set BTRFS_SUBVOLS ,home,snapshots  # top-level btrfs subvolumes to create (starts with ',' and no 'boot')

# SYSTEM

set HOSTNAME abyss  # your machine's hostname
set HARDWARECLOCK UTC  # change this if time isn't stored as UTC
set TIMEZONE Australia/Sydney  # your timezone
set KEYMAP us  # keymap to load
set LANG en_US  # system language
set LOCALES en_US  # comma-separated list of locales

set DRACUT_MODS drm  # comma-separated list of modules to load

# XBPS

set XBPS_REPO https://ftp.swin.edu.au/voidlinux/current  # packages repository

# USERS

set ROOT_PASS SUPER_STRONG_PASSWORD  # root password
set USER_NAME SUPER_USER  # name of the default user
set USER_PASS SUPER_STRONG_PASSWORD  # password of the default user
