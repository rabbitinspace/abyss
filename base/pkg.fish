# Installs base system packages.
#
# Args:
#   $repo - packages repository url.
#   $root - installation root directory.
function install_base -a repo -a root
  set -l pkgs (__base_packages | string split " ")

  if echo $pkgs | string match -qr 'intel'
    xbps_install $repo -r $root void-repo-nonfree || return 1
  end

  xbps_install $repo -r $root $pkgs || return 1
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

  set -a pkgs (__mcode_pkg)

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
