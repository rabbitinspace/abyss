#!/usr/bin/env fish

set DIR (dirname (status --current-filename))

source "$DIR/config.fish"
source "$DIR/common/log.fish"
source "$DIR/common/xbps.fish"

source "$DIR/cron.fish"
source "$DIR/dhcp.fish"
source "$DIR/firewall.fish"
source "$DIR/ntp.fish"
source "$DIR/slog.fish"
source "$DIR/sys.fish"
source "$DIR/trim.fish"

function main
  if test $EXT_CRON = yes
    log_info "Configuring cron."
    if ! cfg_cron $XBPS_REPO
      log_err "Failed to configure cron."
    end
  end

  if test $EXT_DHCP = yes
    log_info "Configuring dhcp."
    if ! cfg_dhcp
      log_err "Failed to configure dhcp."
    end
  end

  if test $EXT_NTP = yes
    log_info "Configuring ntp."
    if ! cfg_ntp $XBPS_REPO
      log_err "Failed to configure ntp."
    end
  end

  if test $EXT_SLOG = yes
    log_info "Configuring syslog."
    if ! cfg_slog $XBPS_REPO
      log_err "Failed to configure syslog."
    end
  end

  if test $EXT_FIREWALL = yes
    log_info "Configuring firewall."
    if ! cfg_firewall
      log_err "Failed to configure firewall."
    end
  end

  if test $EXT_SYS_RULES = yes
    log_info "Configuring sysctl rules."
    if ! cfg_sys_rules
      log_err "Failed to configure sysctl rues."
    end
  end

  if test $EXT_TRIM = yes
    log_info "Configuring TRIM job."
    if ! cfg_trim
      log_err "Failed to configure TRIM job."
    end
  end
end

main $argv
