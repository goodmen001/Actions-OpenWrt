#!/bin/bash
#========================================================================================================================
# https://github.com/oppen321/ZeroWrt-Action
# Description: Automatically Build OpenWrt for X86_64
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/openwrt/openwrt / Branch: openwrt-24.10
#========================================================================================================================

# Nginx
sed -i "s/large_client_header_buffers 2 1k/large_client_header_buffers 4 32k/g" feeds/packages/net/nginx-util/files/uci.conf.template
sed -i "s/client_max_body_size 128M/client_max_body_size 2048M/g" feeds/packages/net/nginx-util/files/uci.conf.template
sed -i '/client_max_body_size/a\\tclient_body_buffer_size 8192M;' feeds/packages/net/nginx-util/files/uci.conf.template
sed -i '/client_max_body_size/a\\tserver_names_hash_bucket_size 128;' feeds/packages/net/nginx-util/files/uci.conf.template
sed -i '/ubus_parallel_req/a\        ubus_script_timeout 600;' feeds/packages/net/nginx/files-luci-support/60_nginx-luci-support
sed -ri "/luci-webui.socket/i\ \t\tuwsgi_send_timeout 600\;\n\t\tuwsgi_connect_timeout 600\;\n\t\tuwsgi_read_timeout 600\;" feeds/packages/net/nginx/files-luci-support/luci.locations
sed -ri "/luci-cgi_io.socket/i\ \t\tuwsgi_send_timeout 600\;\n\t\tuwsgi_connect_timeout 600\;\n\t\tuwsgi_read_timeout 600\;" feeds/packages/net/nginx/files-luci-support/luci.locations

# uwsgi
sed -i 's,procd_set_param stderr 1,procd_set_param stderr 0,g' feeds/packages/net/uwsgi/files/uwsgi.init
sed -i 's,buffer-size = 10000,buffer-size = 131072,g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
sed -i 's,logger = luci,#logger = luci,g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
sed -i '$a cgi-timeout = 600' feeds/packages/net/uwsgi/files-luci-support/luci-*.ini
sed -i 's/threads = 1/threads = 2/g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
sed -i 's/processes = 3/processes = 4/g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini
sed -i 's/cheaper = 1/cheaper = 2/g' feeds/packages/net/uwsgi/files-luci-support/luci-webui.ini

# rpcd
sed -i 's/option timeout 30/option timeout 60/g' package/system/rpcd/files/rpcd.config
sed -i 's#20) \* 1000#60) \* 1000#g' feeds/luci/modules/luci-base/htdocs/luci-static/resources/rpc.js

# distfeeds.conf
mkdir -p files/etc/opkg
cat > files/etc/opkg/distfeeds.conf <<EOF
src/gz openwrt_base https://mirrors.aliyun.com/openwrt/releases/24.10.0/packages/x86_64/base
src/gz openwrt_luci https://mirrors.aliyun.com/openwrt/releases/24.10.0/packages/x86_64/luci
src/gz openwrt_packages https://mirrors.aliyun.com/openwrt/releases/24.10.0/packages/x86_64/packages
src/gz openwrt_routing https://mirrors.aliyun.com/openwrt/releases/24.10.0/packages/x86_64/routing
src/gz openwrt_telephony https://mirrors.aliyun.com/openwrt/releases/24.10.0/packages/x86_64/telephony
EOF

# samba4
sed -i 's/#aio read size = 0/aio read size = 0/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#aio write size = 0/aio write size = 0/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/bind interfaces only = yes/bind interfaces only = no/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#create mask/create mask/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/#directory mask/directory mask/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/0666/0644/g;s/0744/0755/g;s/0777/0755/g' feeds/luci/applications/luci-app-samba4/htdocs/luci-static/resources/view/samba4.js
sed -i 's/0666/0644/g;s/0777/0755/g' feeds/packages/net/samba4/files/samba.config
sed -i 's/0666/0644/g;s/0777/0755/g' feeds/packages/net/samba4/files/smb.conf.template

# bash
sed -i 's#ash#bash#g' package/base-files/files/etc/passwd
sed -i '\#export ENV=/etc/shinit#a export HISTCONTROL=ignoredups' package/base-files/files/etc/profile
# mkdir -p files/root
# curl -so files/root/.bash_profile https://git.kejizero.online/zhao/files/raw/branch/main/root/.bash_profile
# curl -so files/root/.bashrc https://git.kejizero.online/zhao/files/raw/branch/main/root/.bashrc

# default LAN IP
# sed -i "s/192.168.1.1/192.168.1.10/g" package/base-files/files/bin/config_generate

# 修改名称
# sed -i 's/OpenWrt/immortalwrt/' package/base-files/files/bin/config_generate

# default-settings
git clone --depth=1 -b openwrt-24.10 https://github.com/oppen321/default-settings package/default-settings

# openwrt patch
git clone --depth=1 -b kernel-6.6 https://github.com/oppen321/OpenWrt-Patch

# make olddefconfig
wget -qO - https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/kernel/0003-include-kernel-defaults.mk.patch | patch -p1

# Luci diagnostics.js
sed -i "s/openwrt.org/www.qq.com/g" feeds/luci/modules/luci-mod-network/htdocs/luci-static/resources/view/network/diagnostics.js

# TTYD
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/utils/ttyd/files/ttyd.init

# bbr
cp -rf OpenWrt-Patch/bbr3/* ./target/linux/generic/backport-6.6/

# bcmfullcone
cp -rf OpenWrt-Patch/bcmfullcone/* ./target/linux/generic/hack-6.6/

### 替换FW4 ###
git clone -b main https://github.com/openwrt/openwrt.git package/openwrt_main
rm -rf ./package/network/config/firewall4
cp -rf ./package/openwrt_main/package/network/config/firewall4 ./package/network/config/firewall4
rm -rf ./package/openwrt_main

# FW4
mkdir -p package/network/config/firewall4/patches
cp -f OpenWrt-Patch/firewall/firewall4_patches/*.patch package/network/config/firewall4/patches/
sed -i 's|$(PROJECT_GIT)/project|https://github.com/openwrt|g' package/network/config/firewall4/Makefile

# libnftnl
mkdir -p package/libs/libnftnl/patches
cp -f OpenWrt-Patch/firewall/libnftnl/*.patch package/libs/libnftnl/patches/

# nftables
mkdir -p package/network/utils/nftables/patches
cp -f OpenWrt-Patch/firewall/nftables/*.patch package/network/utils/nftables/patches/

# Shortcut-FE支持
cp -rf OpenWrt-Patch/sfe/* ./target/linux/generic/hack-6.6/

# NAT6
patch -p1 < OpenWrt-Patch/firewall/100-openwrt-firewall4-add-custom-nft-command-support.patch

# (Shortcut-FE,bcm-fullcone,ipv6-nat,nft-rule,natflow,fullcone6)
pushd feeds/luci
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/firewall/luci/0001-luci-app-firewall-add-nft-fullcone-and-bcm-fullcone-.patch | patch -p1
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/firewall/luci/0002-luci-app-firewall-add-shortcut-fe-option.patch | patch -p1
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/firewall/luci/0003-luci-app-firewall-add-ipv6-nat-option.patch | patch -p1
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/firewall/luci/0004-luci-add-firewall-add-custom-nft-rule-support.patch | patch -p1
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/firewall/luci/0005-luci-app-firewall-add-natflow-offload-support.patch | patch -p1
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/firewall/luci/0006-luci-app-firewall-enable-hardware-offload-only-on-de.patch | patch -p1
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/firewall/luci/0007-luci-app-firewall-add-fullcone6-option-for-nftables-.patch | patch -p1
popd

pushd feeds/luci
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/luci/0001-luci-mod-system-add-modal-overlay-dialog-to-reboot.patch | patch -p1
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/luci/0002-luci-mod-status-displays-actual-process-memory-usage.patch | patch -p1
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/luci/0003-luci-mod-status-storage-index-applicable-only-to-val.patch | patch -p1
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/luci/0004-luci-mod-status-firewall-disable-legacy-firewall-rul.patch | patch -p1
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/luci/0005-luci-mod-system-add-refresh-interval-setting.patch | patch -p1
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/luci/0006-luci-mod-system-mounts-add-docker-directory-mount-po.patch | patch -p1
popd

# 移除 SNAPSHOT 标签
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in
sed -i '/CONFIG_BUILDBOT/d' include/feeds.mk
sed -i 's/;)\s*\\/; \\/' include/feeds.mk

# 替换软件包
rm -rf feeds/packages/lang/golang
rm -rf feeds/packages/utils/coremark
rm -rf feeds/luci/applications/luci-app-alist
rm -rf feeds/packages/net/{alist,zerotier,xray-core,v2ray-core,v2ray-geodata,sing-box,sms-tool}

# golong1.24依赖
git clone --depth=1 -b 24.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# helloworld
git clone --depth=1 -b helloworld https://github.com/oppen321/openwrt-package package/helloworld

# 加载软件源
git clone --depth=1 https://github.com/oppen321/openwrt-package package/openwrt-package
rm -rf package/openwrt-package/luci-app-lucky

# 加载软件源
git clone --depth=1 https://github.com/gdy666/luci-app-lucky package/lucky
rm -rf package/lucky/previews

# banner
# cp -f package/openwrt-package/banner  package/base-files/files/etc/banner

# Docker
rm -rf feeds/luci/applications/luci-app-dockerman
git clone https://github.com/oppen321/luci-app-dockerman feeds/luci/applications/luci-app-dockerman
rm -rf feeds/packages/utils/{docker,dockerd,containerd,runc}
git clone https://github.com/grandway2025/packages_utils_docker feeds/packages/utils/docker
git clone https://github.com/grandway2025/packages_utils_dockerd feeds/packages/utils/dockerd
git clone https://github.com/grandway2025/packages_utils_containerd feeds/packages/utils/containerd
git clone https://github.com/grandway2025/packages_utils_runc feeds/packages/utils/runc
sed -i '/cgroupfs-mount/d' feeds/packages/utils/dockerd/Config.in
sed -i '/sysctl.d/d' feeds/packages/utils/dockerd/Makefile
pushd feeds/packages
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/docker/0001-dockerd-fix-bridge-network.patch | patch -p1
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/docker/0002-docker-add-buildkit-experimental-support.patch | patch -p1
    curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/docker/0003-dockerd-disable-ip6tables-for-bridge-network-by-defa.patch | patch -p1
popd

# UPnP
rm -rf feeds/{packages/net/miniupnpd,luci/applications/luci-app-upnp}
git clone https://github.com/grandway2025/miniupnpd feeds/packages/net/miniupnpd
git clone https://github.com/grandway2025/luci-app-upnp feeds/luci/applications/luci-app-upnp

# opkg
mkdir -p package/system/opkg/patches
curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/opkg/0001-opkg-download-disable-hsts.patch > package/system/opkg/patches/0001-opkg-download-disable-hsts.patch
curl -s https://raw.githubusercontent.com/oppen321/OpenWrt-Patch/refs/heads/kernel-6.6/opkg/0002-libopkg-opkg_install-copy-conffiles-to-the-system-co.patch > package/system/opkg/patches/0002-libopkg-opkg_install-copy-conffiles-to-the-system-co.patch

# 加入作者信息
# sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='ZeroWrt-$(date +%Y%m%d)'/g"  package/base-files/files/etc/openwrt_release
# sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By OPPEN321'/g" package/base-files/files/etc/openwrt_release

# 主题设置
sed -i 's/bing/none/' package/openwrt-package/luci-app-argon-config/root/etc/config/argon
curl -L https://git.kejizero.online/zhao/files/raw/branch/main/images/bg1.jpg -o package/openwrt-package/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
# sed -i 's#<a class="luci-link" href="https://github.com/openwrt/luci" target="_blank">Powered by <%= ver.luciname %> (<%= ver.luciversion %>)</a> /#<a class="luci-link" href="https://www.kejizero.online" target="_blank">探索无限</a> /#' package/openwrt-package/luci-theme-argon/luasrc/view/themes/argon/footer.htm
# sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">ArgonTheme <%# vPKG_VERSION %></a>|<a href="https://github.com/oppen321/ZeroWrt-Action" target="_blank">ZeroWrt-Action</a> |g' package/openwrt-package/luci-theme-argon/luasrc/view/themes/argon/footer.htm
# sed -i 's#<a class="luci-link" href="https://github.com/openwrt/luci" target="_blank">Powered by <%= ver.luciname %> (<%= ver.luciversion %>)</a> /#<a class="luci-link" href="https://www.kejizero.online" target="_blank">探索无限</a> /#' package/openwrt-package/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm
# sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">ArgonTheme <%# vPKG_VERSION %></a>|<a href="https://github.com/oppen321/ZeroWrt-Action" target="_blank">ZeroWrt-Action</a> |g' package/openwrt-package/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm

sed -i "s|_('Firmware Version'), (L.isObject(boardinfo.release) ? boardinfo.release.description + ' / ' : '') + (luciversion || '')|_('Firmware Version'), 'ZeroWrt-VIP-R25.04.6-K6.6.83'|" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js

# istoreos
sed -i 's/iStoreOS/OpenWrt/' package/openwrt-package/istoreos-files/files/etc/board.d/10_system
sed -i 's/192.168.100.1/10.0.0.1/' package/openwrt-package/istoreos-files/Makefile

# update feeds
./scripts/feeds update -a
./scripts/feeds install -a
