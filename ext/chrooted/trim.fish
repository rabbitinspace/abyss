function cfg_trim
  set -l path /etc/cron.weekly/fstrim
  mkdir -p (dirname $path)
  rm -f $path

  __install_script $path || return 1
  chmod +x $path
end

function __install_script -a path
  echo "
#!/usr/bin/env sh
fstrim -v -A || true
" > $path
end
