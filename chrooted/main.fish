#!/usr/bin/env fish

set DIR (dirname (status --current-filename))

source "$DIR/config.fish"
source "$DIR/log.fish"

source "$DIR/confs.fish"

function main
  log_info "Configuring root."
  if ! cfg_root $ROOT_PASS
    log_err "Failed to configure root."
    return 1
  end

  log_info "Configuring hostname."
  if ! cfg_hostname $HOSTNAME
    log_err "Failed to configure hostname."
    return 1
  end

  log_info "Configuring locale."
  if ! cfg_locale $LANG $LOCALES
    log_err "Failed to configure locale."
    return 1
  end

  log_info "Configuring rc.conf"
  if ! cfg_rcconf $HARDWARECLOCK $TIMEZONE $KEYMAP
    log_err "Failed to configure rc.conf."
    return 1
  end

  log_info "Configuring dracut."
  if ! cfg_dracut $DRACUT_MODS
    log_err "Failed to configure dracut."
    return 1
  end

  log_info "Reconfiguring system."
  if ! recfg_all
    log_err "Failed to reconfigure system."
    return 1
  end
end

main $argv
