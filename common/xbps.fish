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
