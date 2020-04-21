set ROOT (type -q git && git rev-parse --show-toplevel 2>/dev/null || pwd)
set DIR (dirname (status --current-filename))

source "$ROOT/common/log.fish"
source "$DIR/pkg.fish"

function bootstrap_system
  log_info "Installing base system."
  if ! install_base $XBPS_REPO /mnt
    log_err "Failed to install base system."
    return 1
  end
end
