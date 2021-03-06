#!/usr/bin/env fish

set DIR (dirname (status --current-filename))

source "$DIR/config.fish"
source "$DIR/common/log.fish"

source "$DIR/confs.fish"
source "$DIR/users.fish"
source "$DIR/xbps.fish"

function main
  __pre_cfg || return 1
  __cfg || return 1
  __post_cfg || return 1
end

function __pre_cfg
  log_info "Configuring permissions."
  if ! cfg_perm
    log_err "Failed to configure permissions."
    return 1
  end
end

function __cfg
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

function __post_cfg
  log_info "Creating user."
  if ! cfg_user $USER_NAME $USER_PASS $USER_GROUPS $USER_SHELL
    log_err "Failed to create user."
    return 1
  end

  log_info "Configuring XBPS repository."
  if ! cfg_repo $XBPS_REPO
    log_err "Failed to configure XBPS repository."
    return 1
  end
end

main $argv
