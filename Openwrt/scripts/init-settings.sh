#!/bin/bash

# Set default theme to luci-theme-argon
uci set luci.main.mediaurlbase='/luci-static/design'
uci commit luci

# diagnostics
uci set luci.diag.dns='www.qq.com'
uci set luci.diag.ping='www.qq.com'
uci set luci.diag.route='www.qq.com'
uci commit luci

# 设置主机名映射，解决安卓原生TV首次连不上网的问题
uci add dhcp domain
uci set "dhcp.@domain[-1].name=time.android.com"
uci set "dhcp.@domain[-1].ip=203.107.6.88"
uci commit dhcp

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''
uci commit

# docker mirror
if [ -f /etc/config/dockerd ] && [ $(grep -c daocloud.io /etc/config/dockerd) -eq '0' ]; then
    uci add_list dockerd.globals.registry_mirrors="https://docker.m.daocloud.io"
    uci commit dockerd
fi

# adguardhome
chmod +x /usr/share/AdGuardHome/addhost.sh

# Smartdns related settings
uci add smartdns server
uci set smartdns.@server[0].enabled='1'
uci set smartdns.@server[0].type='udp'
uci set smartdns.@server[0].name='清华大学TUNA协会'
uci set smartdns.@server[0].ip='101.6.6.6'
uci set smartdns.@server[0].server_group='smartdns-China'
uci set smartdns.@server[0].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[1].enabled='1'
uci set smartdns.@server[1].type='udp'
uci set smartdns.@server[1].name='114'
uci set smartdns.@server[1].ip='114.114.114.114'
uci set smartdns.@server[1].server_group='smartdns-China'
uci set smartdns.@server[1].blacklist_ip='0'
uci set smartdns.@server[1].port='53'
uci add smartdns server
uci set smartdns.@server[2].enabled='1'
uci set smartdns.@server[2].type='udp'
uci set smartdns.@server[2].name='ail dns ipv4'
uci set smartdns.@server[2].ip='223.5.5.5'
uci set smartdns.@server[2].port='53'
uci set smartdns.@server[2].server_group='smartdns-China'
uci set smartdns.@server[2].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[3].enabled='1'
uci set smartdns.@server[3].name='Ali DNS'
uci set smartdns.@server[3].ip='https://dns.alidns.com/dns-query'
uci set smartdns.@server[3].type='https'
uci set smartdns.@server[3].no_check_certificate='0'
uci set smartdns.@server[3].server_group='smartdns-China'
uci set smartdns.@server[3].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[4].enabled='1'
uci set smartdns.@server[4].name='360 Secure DNS'
uci set smartdns.@server[4].type='https'
uci set smartdns.@server[4].no_check_certificate='0'
uci set smartdns.@server[4].server_group='smartdns-China'
uci set smartdns.@server[4].blacklist_ip='0'
uci set smartdns.@server[4].ip='https://doh.360.cn/dns-query'
uci add smartdns server
uci set smartdns.@server[5].enabled='1'
uci set smartdns.@server[5].name='DNSPod Public DNS+'
uci set smartdns.@server[5].ip='https://doh.pub/dns-query'
uci set smartdns.@server[5].type='https'
uci set smartdns.@server[5].no_check_certificate='0'
uci set smartdns.@server[5].server_group='smartdns-China'
uci set smartdns.@server[5].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[6].enabled='1'
uci set smartdns.@server[6].type='udp'
uci set smartdns.@server[6].name='baidu dns'
uci set smartdns.@server[6].ip='180.76.76.76'
uci set smartdns.@server[6].port='53'
uci set smartdns.@server[6].server_group='smartdns-China'
uci set smartdns.@server[6].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[7].enabled='1'
uci set smartdns.@server[7].type='udp'
uci set smartdns.@server[7].name='360dns'
uci set smartdns.@server[7].ip='101.226.4.6'
uci set smartdns.@server[7].port='53'
uci set smartdns.@server[7].server_group='smartdns-China'
uci set smartdns.@server[7].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[8].enabled='1'
uci set smartdns.@server[8].type='udp'
uci set smartdns.@server[8].name='dnspod'
uci set smartdns.@server[8].ip='119.29.29.29'
uci set smartdns.@server[8].port='53'
uci set smartdns.@server[8].blacklist_ip='0'
uci set smartdns.@server[8].server_group='smartdns-China'
uci add smartdns server
uci set smartdns.@server[9].enabled='1'
uci set smartdns.@server[9].name='Cloudflare-tls'
uci set smartdns.@server[9].ip='1.1.1.1'
uci set smartdns.@server[9].type='tls'
uci set smartdns.@server[9].server_group='smartdns-Overseas'
uci set smartdns.@server[9].exclude_default_group='0'
uci set smartdns.@server[9].blacklist_ip='0'
uci set smartdns.@server[9].no_check_certificate='0'
uci set smartdns.@server[9].port='853'
uci set smartdns.@server[9].spki_pin='GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg='
uci add smartdns server
uci set smartdns.@server[10].enabled='1'
uci set smartdns.@server[10].name='Google_DNS-tls'
uci set smartdns.@server[10].type='tls'
uci set smartdns.@server[10].server_group='smartdns-Overseas'
uci set smartdns.@server[10].exclude_default_group='0'
uci set smartdns.@server[10].blacklist_ip='0'
uci set smartdns.@server[10].no_check_certificate='0'
uci set smartdns.@server[10].port='853'
uci set smartdns.@server[10].ip='8.8.4.4'
uci set smartdns.@server[10].spki_pin='r/fTokourI3+um9Rws4XrHG6fWEmHpZ8iWnOUjzwwjQ='
uci add smartdns server
uci set smartdns.@server[11].enabled='1'
uci set smartdns.@server[11].name='Quad9-tls'
uci set smartdns.@server[11].ip='9.9.9.9'
uci set smartdns.@server[11].type='tls'
uci set smartdns.@server[11].server_group='smartdns-Overseas'
uci set smartdns.@server[11].exclude_default_group='0'
uci set smartdns.@server[11].blacklist_ip='0'
uci set smartdns.@server[11].no_check_certificate='0'
uci set smartdns.@server[11].port='853'
uci set smartdns.@server[11].spki_pin='/SlsviBkb05Y/8XiKF9+CZsgCtrqPQk5bh47o0R3/Cg='
uci add smartdns server
uci set smartdns.@server[12].enabled='1'
uci set smartdns.@server[12].name='quad9-ipv6'
uci set smartdns.@server[12].ip='2620:fe::fe'
uci set smartdns.@server[12].port='9953'
uci set smartdns.@server[12].type='udp'
uci set smartdns.@server[12].server_group='smartdns-Overseas'
uci set smartdns.@server[12].exclude_default_group='0'
uci set smartdns.@server[12].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[13].enabled='1'
uci set smartdns.@server[13].name='谷歌DNS'
uci set smartdns.@server[13].ip='https://dns.google/dns-query'
uci set smartdns.@server[13].type='https'
uci set smartdns.@server[13].no_check_certificate='0'
uci set smartdns.@server[13].server_group='smartdns-Overseas'
uci set smartdns.@server[13].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[14].enabled='1'
uci set smartdns.@server[14].name='Cloudflare DNS '
uci set smartdns.@server[14].ip='https://dns.cloudflare.com/dns-query'
uci set smartdns.@server[14].type='https'
uci set smartdns.@server[14].no_check_certificate='0'
uci set smartdns.@server[14].server_group='smartdns-Overseas'
uci set smartdns.@server[14].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[15].enabled='1'
uci set smartdns.@server[15].name='CIRA Canadian Shield DNS'
uci set smartdns.@server[15].ip='https://private.canadianshield.cira.ca/dns-query'
uci set smartdns.@server[15].type='https'
uci set smartdns.@server[15].no_check_certificate='0'
uci set smartdns.@server[15].server_group='smartdns-Overseas'
uci set smartdns.@server[15].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[16].enabled='1'
uci set smartdns.@server[16].name='Restena DNS'
uci set smartdns.@server[16].ip='https://kaitain.restena.lu/dns-query'
uci set smartdns.@server[16].type='https'
uci set smartdns.@server[16].no_check_certificate='0'
uci set smartdns.@server[16].server_group='smartdns-Overseas'
uci set smartdns.@server[16].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[17].enabled='1'
uci set smartdns.@server[17].name='Quad9 DNS'
uci set smartdns.@server[17].ip='https://dns.quad9.net/dns-query'
uci set smartdns.@server[17].type='https'
uci set smartdns.@server[17].no_check_certificate='0'
uci set smartdns.@server[17].server_group='smartdns-Overseas'
uci set smartdns.@server[17].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[18].enabled='1'
uci set smartdns.@server[18].name='CZ.NIC ODVR'
uci set smartdns.@server[18].ip='https://odvr.nic.cz/doh'
uci set smartdns.@server[18].type='https'
uci set smartdns.@server[18].no_check_certificate='0'
uci set smartdns.@server[18].server_group='smartdns-Overseas'
uci set smartdns.@server[18].blacklist_ip='0'
uci add smartdns server
uci set smartdns.@server[19].enabled='1'
uci set smartdns.@server[19].name='AhaDNS-Spain'
uci set smartdns.@server[19].ip='https://doh.es.ahadns.net/dns-query '
uci set smartdns.@server[19].type='https'
uci set smartdns.@server[19].no_check_certificate='0'
uci set smartdns.@server[19].server_group='smartdns-Overseas'
uci set smartdns.@server[19].blacklist_ip='0'
uci commit smartdns
/etc/init.d/smartdns restart

exit 0
