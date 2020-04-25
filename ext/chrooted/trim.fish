function cfg_trim
  set -l path /etc/cron.weekly/fstrim
  __install_script || return 1
  chmod a-x $path
end

function __install_script -a path
  echo "
#!/usr/bin/env sh
fstrim -v -A || true
" > $path
end
