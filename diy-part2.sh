#!/usr/bin/env bash
set -euo pipefail

sed -i 's/\r$//' .config

# 选择设备
sed -i -E '/^CONFIG_TARGET_(ramips_mt7621_DEVICE_|DEVICE_ramips_mt7621_DEVICE_)/d' .config
cat >> .config <<'EOF'
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7621=y
CONFIG_TARGET_ramips_mt7621_DEVICE_qihoo_360t6gs=y
CONFIG_TARGET_DEVICE_PACKAGES_ramips_mt7621_DEVICE_qihoo_360t6gs="kmod-mt7915-firmware"
EOF

# UA3F + 依赖（参考官方教程）
cat >> .config <<'EOF'
CONFIG_PACKAGE_ua3f=y
CONFIG_PACKAGE_kmod-nft-queue=y
CONFIG_PACKAGE_kmod-nft-tproxy=y
CONFIG_PACKAGE_iptables-mod-nfqueue=y
CONFIG_PACKAGE_iptables-mod-ipopt=y
CONFIG_PACKAGE_kmod-ipt-ipopt=y
CONFIG_PACKAGE_ipset=y
CONFIG_PACKAGE_iptables-mod-conntrack-extra=y
EOF

# 网页终端
cat >> .config <<'EOF'
CONFIG_PACKAGE_ttyd=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-i18n-ttyd-zh-cn=y
EOF

echo "diy-part2 done: UA3F + deps + ttyd"
