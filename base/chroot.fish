function bootstrap_chrooted -a root
  __bind_sys $root
end

function __bind_sys -a root
  for dir in dev proc sys run
    mkdir -p "$root/$dir"
    mount --rbind /$dir "$root/$dir" || return 1
    mount --make-rslave "$root/$dir" || return 1
  end
end
