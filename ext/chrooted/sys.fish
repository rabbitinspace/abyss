function cfg_sys_rules
  set -l path /etc/sysctl.d/99-sysctl.conf
  mkdir -p (dirname $path)
  rm -f $path

  __kernel_rules $path
  __network_rules $path
end

function __kernel_rules -a path
  # see https://wiki.archlinux.org/index.php/Security#Kernel_hardening

  echo '
# kernel rules

kernel.unprivileged_bpf_disabled = 1
net.core.bpf_jit_harden = 2
kernel.randomize_va_space = 2
' >> $path
end

function __network_rules -a path
  # see https://wiki.archlinux.org/index.php/Sysctl#Networking

  echo '
# networking rules

net.core.netdev_max_backlog = 16384

net.core.somaxconn = 8192

net.core.rmem_default = 1048576
net.core.rmem_max = 16777216
net.core.wmem_default = 1048576
net.core.wmem_max = 16777216
net.core.optmem_max = 65536

net.ipv4.tcp_rmem = 4096 1048576 2097152
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192

net.ipv4.tcp_fastopen = 3

net.ipv4.tcp_max_syn_backlog = 8192

net.ipv4.tcp_max_tw_buckets = 2000000

net.ipv4.tcp_tw_reuse = 1

net.ipv4.tcp_fin_timeout = 10

net.ipv4.tcp_slow_start_after_idle = 0

net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_probes = 6

net.core.default_qdisc = cake
net.ipv4.tcp_congestion_control = bbr

net.ipv4.tcp_syncookies = 1

net.ipv4.tcp_rfc1337 = 1

net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1

net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

net.ipv4.icmp_echo_ignore_all = 1
net.ipv6.icmp.echo_ignore_all = 1
' >> $path
end
