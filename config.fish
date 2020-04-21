# Partitioning

set LUKS_PASSWORD "<REPLACE>"  # disk encryption password
set LUKS_LABEL void  # decrypted root partition label
set MOUNT_OPTS rw,noatime,nodiratime,ssd,compress=zstd,space_cache  # mount options for the root partition
set BTRFS_SUBVOLS ,home,snapshots  # top-level btrfs subvolumes to create (starts with ',' and no 'boot')

# Base system

set HOSTNAME abyss
set HARDWARECLOCK UTC
set TIMEZONE "Australia/Sydney"
set KEYMAP us
set LOCALES "en_US.UTF-8 UTF-8"  # comma-separated list of locales

set XBPS_REPO "https://alpha.de.repo.voidlinux.org/current"
