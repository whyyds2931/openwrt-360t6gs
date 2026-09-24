#!/usr/bin/env bash
set -euo pipefail

# Keep the config symbol used by the official OpenWrt target.
sed -i 's/\r$//' .config
sed -i -E '/^CONFIG_TARGET_(DEVICE_)?ramips_mt7621_DEVICE_.*=y$/d' .config
printf '%s\n' \
	'CONFIG_TARGET_ramips=y' \
	'CONFIG_TARGET_ramips_mt7621=y' \
	'CONFIG_TARGET_ramips_mt7621_DEVICE_360_360t6gs=y' \
	'CONFIG_TARGET_DEVICE_PACKAGES_ramips_mt7621_DEVICE_360_360t6gs="kmod-mt7915e kmod-mt7915-firmware"' >> .config

grep -qx 'CONFIG_TARGET_ramips_mt7621_DEVICE_360_360t6gs=y' .config
test "$(grep -c '^CONFIG_TARGET_ramips_mt7621_DEVICE_.*=y$' .config)" -eq 1
echo 'Selected native device: 360_360t6gs'
