# 修改固件参数
# ============================================================================================

# 1-修改管理地址
sed -i 's/192.168.1.1/192.168.99.1/g' package/base-files/files/bin/config_generate

# 2-修改内核版本
sed -i 's/KERNEL_PATCHVER:=6.6/KERNEL_PATCHVER:=6.12/g' ./target/linux/x86/Makefile

# 3-删除默认密码
sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings

# 4-修改默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-opentomcat/g' feeds/luci/collections/luci/Makefile

# 5-修改时间格式
sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/*/index.htm

# 6-添加编译日期
sed -i 's/IMG_PREFIX:=/IMG_PREFIX:=$(BUILD_DATE_PREFIX)-/g' ./include/image.mk
sed -i '/DTS_DIR:=$(LINUX_DIR)/a\BUILD_DATE_PREFIX := $(shell date +'%F')' ./include/image.mk

# 7-只显示CPU型号
sed -i 's/${g}.*/${a}${b}${c}${d}${e}${f}${hydrid}/g' package/lean/autocore/files/x86/autocore

# 添加外部插件
# =======================================================================================================================

# 1-添加 ShadowSocksR Plus+ 插件
# echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default

# 2-添加 PowerOff 关机插件
git clone https://github.com/WukongMaster/luci-app-poweroff.git package/luci-app-poweroff

# 3-添加 opentomcat 主题
git clone https://github.com/WukongMaster/luci-theme-opentomcat.git package/luci-theme-opentomcat

# 4-添加 luci-theme-kucat 主题
git clone https://github.com/sirpdboy/luci-theme-kucat.git package/luci-theme-kucat

# 5-添加 OpenClash 插件
sed -i '$a\src-git openclash https://github.com/vernesong/OpenClash' ./feeds.conf.default

# 6-添加 PassWall 插件
echo "src-git passwall https://github.com/xiaorouji/openwrt-passwall.git;main" >> "feeds.conf.default"
echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages.git;main" >> "feeds.conf.default"

# 7-添加外部软件源
# git clone -b lede https://github.com/zouchanggan/openwrt-packages ./package/small
git clone https://git.kejizero.online/zhao/openwrt_helloworld.git package/helloworld -b v5
git clone https://github.com/oppen321/openwrt-package package/openwrt-package

# add app GF
src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main package/luci-app-nikki

# 8-删除依赖(防止插件冲突，删除重复)
rm -rf feeds/packages/net/{xray-core,v2ray-core,v2ray-geodata,sing-box,adguardhome,socat,zerotier}
rm -rf feeds/packages/net/alist feeds/luci/applications/luci-app-alist
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/packages/lang/golang

# 9-更新替换golang
# git clone https://github.com/kenzok8/golang feeds/packages/lang/golang
# git clone https://github.com/kenzok8/golang -b 1.23 feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# 10-更新feeds 
./scripts/feeds update -a && ./scripts/feeds install -a
