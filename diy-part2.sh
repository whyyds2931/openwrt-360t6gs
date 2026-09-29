#!/usr/bin/env bash
set -euo pipefail

sed -i 's/\r$//' .config

# Remove every previous board selection, including stale adslr/360 symbols.
sed -i -E '/^CONFIG_TARGET_(ramips_mt7621_DEVICE_|DEVICE_ramips_mt7621_DEVICE_)/d' .config
cat >> .config <<'EOF'
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7621=y
CONFIG_TARGET_ramips_mt7621_DEVICE_qihoo_360t6gs=y
CONFIG_TARGET_DEVICE_PACKAGES_ramips_mt7621_DEVICE_qihoo_360t6gs="kmod-mt7915-firmware"
EOF

grep -qx 'CONFIG_TARGET_ramips_mt7621_DEVICE_qihoo_360t6gs=y' .config
test "$(grep -c '^CONFIG_TARGET_ramips_mt7621_DEVICE_.*=y$' .config)" -eq 1
! grep -q '360_360t6gs\|adslr_g7' .config
echo 'Selected native device: qihoo_360t6gs'

# ============ 校园网过检测 + 终端 + 网络优化插件 ============

# --- UA2F (改 User-Agent 防校园网检测) ---
cat >> .config <<'EOF'
CONFIG_PACKAGE_ua2f=y
CONFIG_PACKAGE_luci-app-ua2f=y
CONFIG_PACKAGE_luci-i18n-ua2f-zh-cn=y
CONFIG_PACKAGE_iptables-mod-nfqueue=y
CONFIG_PACKAGE_kmod-nfnetlink-queue=y
EOF

# --- 网页终端 (ttyd) ---
cat >> .config <<'EOF'
CONFIG_PACKAGE_ttyd=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-i18n-ttyd-zh-cn=y
EOF

# --- 深澜/锐捷校园网认证 (mentohust) ---
cat >> .config <<'EOF'
CONFIG_PACKAGE_mentohust=y
CONFIG_PACKAGE_luci-app-mentohust=y
CONFIG_PACKAGE_luci-i18n-mentohust-zh-cn=y
EOF

# --- TTL 修改 (防 TTL 检测) ---
cat >> .config <<'EOF'
CONFIG_PACKAGE_iptables-mod-ipopt=y
CONFIG_PACKAGE_kmod-ipt-ipopt=y
EOF

# --- 网络堵塞优化 (fullconenat + cake qdisc) ---
cat >> .config <<'EOF'
CONFIG_PACKAGE_kmod-nft-fullcone=y
CONFIG_PACKAGE_kmod-sched-cake=y
CONFIG_PACKAGE_luci-app-nft-qos=y
EOF

# --- 基础工具 ---
cat >> .config <<'EOF'
CONFIG_PACKAGE_curl=y
CONFIG_PACKAGE_opkg=y
CONFIG_PACKAGE_usb-modeswitch=y
EOF

echo "Added campus network + terminal + network optimization packages"