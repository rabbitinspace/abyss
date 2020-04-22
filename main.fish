#!/usr/bin/env fish

set DIR (dirname (status --current-filename))

function main
  "$DIR/disk/main.fish"
  "$DIR/base/main.fish"
end

main $argv
