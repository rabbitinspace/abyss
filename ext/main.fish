#!/usr/bin/env fish

set ROOT (type -q git && git rev-parse --show-toplevel 2>/dev/null || pwd)
set DIR (dirname (status --current-filename))

source "$ROOT/common/log.fish"
source "$ROOT/common/chroot.fish"

source "$ROOT/config.fish"

function main
  log_info "Chrooting for extended setup."
  if ! run_chrooted /mnt "$DIR/chrooted" $ROOT
    log_err "Extended setup failed."
    return 1
  end
end

main $argv
