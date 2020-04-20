# disk encryption password
set LUKS_PASSWORD "<REPLACE>"

# decrypted root partition label
set LUKS_LABEL void

# mount options for the root partition
set MOUNT_OPTS rw,noatime,nodiratime,ssd,compress=zstd,space_cache

# top-level btrfs subvolumes to create (don't use 'boot' here)
set BTRFS_SUBVOLS ,home,snapshots
