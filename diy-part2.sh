#!/bin/bash
#=================================================
# DIY 脚本 2 - make defconfig 前强制锁定设备
#=================================================

# 强制只编译360t6gs，关闭其他所有设备
sed -i 's/CONFIG_TARGET_DEVICE_.*=y/# &/g' .config
echo 'CONFIG_TARGET_ramips=y' >> .config
echo 'CONFIG_TARGET_ramips_mt7621=y' >> .config
echo 'CONFIG_TARGET_DEVICE_ramips_mt7621_DEVICE_qihoo_360t6gs=y' >> .config
echo 'CONFIG_TARGET_DEVICE_PACKAGES_ramips_mt7621_DEVICE_qihoo_360t6gs="kmod-mt7915-firmware"' >> .config
echo "设备已锁定为 qihoo_360t6gs"
grep "CONFIG_TARGET_DEVICE" .config

echo "=== DIY 2 完成 ==="
