#!/usr/bin/env fish

set ROOT (type -q git && git rev-parse --show-toplevel 2>/dev/null || pwd)
set DIR (dirname (status --current-filename))

source "$ROOT/common/log.fish"
source "$ROOT/common/chroot.fish"
source "$ROOT/common/xbps.fish"

source "$ROOT/config.fish"

source "$DIR/xbps.fish"

function main
  if test $EXT_SETUP != yes
    log_info "Skipping extended setup."
    return
  end

  log_info "Installing extended packages."
  if ! install_extended $XBPS_REPO /mnt $EXT_CRON $EXT_NTP $EXT_SLOG
    log_err "Failed to install extended packages."
    return 1
  end

  log_info "Chrooting for extended setup."
  if ! run_chrooted /mnt "$DIR/chrooted" $ROOT
    log_err "Extended setup failed."
    return 1
  end
end

main $argv
