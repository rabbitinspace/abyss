# Reconfigures all affected by extended setup packages.
function recfg_all
  set -l kver (ls /usr/lib/modules | xargs -L 1 basename) || return 1
  set -l kmm (echo $kver | string split '.' | head -n 2 | string join '.')

  dracut --force --kver $kver || return 1
  xbps-reconfigure -f "linux$kmm"
end
