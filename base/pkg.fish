# Installs base system packages.
#
# Args:
#   $repo - packages repository url.
#   $root - installation root directory.
function install_base -a repo -a root
  set -l pkgs (__base_packages | string split " ")
  set -l mcode (__mcode_pkg)

  xbps_install $repo -r $root $pkgs || return 1
  if echo $mcode | string match -qr 'intel'
    xbps_install "$repo/nonfree" -r $root $mcode || return 1
  else
    xbps_install $repo -r $root $mcode || return 1
  end
end

# Installs given packages from specified repository.
#
# Args:
#   $repo - packages repository url.
#   $... - list of packages to install.
function xbps_install -a repo
  xbps-install \
    --force \
    --ignore-conf-repos \
    --sync \
    --yes \
    --repository $repo \
    $argv[2..-1]
end

# Prints base system packages to install.
function __base_packages
  set -l pkgs \
    base-system \
    cryptsetup \
    btrfs-progs \
    grub-x86_64-efi \
    fish-shell

  echo $pkgs
end

# Prints microcode package for current cpu.
function __mcode_pkg
  set -l vendor (cat /proc/cpuinfo | grep vendor | uniq)
  if string match -i '*intel' $vendor >/dev/null
    echo intel-ucode
  else if string match -i '*amd' $vendor >/dev/null
    echo linux-firmware-amd
  end
end
