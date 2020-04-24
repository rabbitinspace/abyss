# Configures default XBPS repository.
#
# Args:
#   $url - repository URL to use by default.
function cfg_repo -a url
  echo "repository=$url" > /etc/xbps.d/00-repository-main.conf
end
