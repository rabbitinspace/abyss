# Partitioning

set LUKS_PASS "<REPLACE>"  # disk encryption password
set LUKS_KEY volume.key  # name of the key to prevent entering decryption password twice
set LUKS_PATH ''  # path to the root partition, will be set automatically
set LUKS_LABEL void  # decrypted root partition label
set MOUNT_OPTS rw,noatime,nodiratime,ssd,compress=zstd,space_cache  # mount options for the root partition
set BTRFS_SUBVOLS ,home,snapshots  # top-level btrfs subvolumes to create (starts with ',' and no 'boot')

# Base system

set HOSTNAME abyss  # your machine's hostname
set HARDWARECLOCK UTC  # change this if time isn't stored as UTC
set TIMEZONE "Australia/Sydney"  # your timezone
set KEYMAP us  # keymap to load
set LANG en_US  # system language
set LOCALES "en_US"  # comma-separated list of locales

set XBPS_REPO "https://alpha.de.repo.voidlinux.org/current"  # packages repository
