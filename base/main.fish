set ROOT (type -q git && git rev-parse --show-toplevel 2>/dev/null || pwd)
set DIR (dirname (status --current-filename))

source "$ROOT/common/log.fish"

source "$DIR/pkg.fish"
source "$DIR/tabs.fish"
source "$DIR/key.fish"
source "$DIR/grub.fish"

function bootstrap_system
  log_info "Installing base system."
  if ! install_base $XBPS_REPO /mnt
    log_err "Failed to install base system."
    return 1
  end

  log_info "Enable autodecryption of the root partition."
  if ! autodecrypt $LUKS_PATH $LUKS_PASS $LUKS_KEY
    log_err "Failed to install additional decryption key."
    return 1
  end

  log_info "Generating fstab."
  if ! gen_fstab "$ROOT/resources"
    log_err "Failed to generate fstab."
    return 1
  end

  log_info "Generating crypttab."
  if ! gen_crypttab $LUKS_LABEL $LUKS_KEY
    log_err "Failed to generate crypttab."
    return 1
  end

  log_info "Setting GRUB defaults."
  if ! set_grub_defaults $LUKS_LABEL
    log_err "Failed to set GRUB defaults."
    return 1
  end
end
