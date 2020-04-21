# Prints error message.
function log_err -a msg
  __log_msg "ERR: $msg" red
end

# Prints info message.
function log_info -a msg
  __log_msg "INF: $msg" normal
end

# Prints a message to STDERR with a given color.
function __log_msg -a msg -a color
  set_color $color
  printf "$msg\n" >&2
  set_color normal
end
