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
