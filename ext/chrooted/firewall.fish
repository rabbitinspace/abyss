function cfg_firewall
  cp /etc/iptables/simple_firewall.rules /etc/iptables/iptables.rules
  __enable_rules
end

function __enable_rules
  set -l run '
if [ -e /etc/iptables/iptables.rules ]; then
  iptables-restore /etc/iptables/iptables.rules
fi
'

  if ! (cat /etc/rc.local | grep iptables-restore >/dev/null)
    echo $run >> /etc/rc.local
  end
end
