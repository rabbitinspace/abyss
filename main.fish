#!/usr/bin/env fish

set DIR (dirname (status --current-filename))

function main
  "$DIR/disk/main.fish" || return 1
  "$DIR/base/main.fish" || return 1
end

main $argv
