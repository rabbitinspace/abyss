function cfg_firewall
  cp /etc/iptables/simple_firewall.rules /etc/iptables/iptables.rules
  __enable_rules
end

function __enable_rules
  echo "
if [ -e /etc/iptables/iptables.rules ]; then
  iptables-restore /etc/iptables/iptables.rules
fi
" >> /etc/rc.local
end
