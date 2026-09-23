#!/usr/bin/env bash
set -euo pipefail

# Keep exactly one MT7621 device selected before the first defconfig pass.
sed -i 's/\r$//' .config
sed -i -E '/^CONFIG_TARGET_(DEVICE_)?ramips_mt7621_DEVICE_.*=y$/d' .config
printf '%s\n' \
	'CONFIG_TARGET_ramips=y' \
	'CONFIG_TARGET_ramips_mt7621=y' \
	'CONFIG_TARGET_ramips_mt7621_DEVICE_qihoo_360t6gs=y' \
	'CONFIG_TARGET_DEVICE_PACKAGES_ramips_mt7621_DEVICE_qihoo_360t6gs="kmod-mt7915-firmware"' >> .config

grep -qx 'CONFIG_TARGET_ramips_mt7621_DEVICE_qihoo_360t6gs=y' .config
if grep -q '^CONFIG_TARGET_ramips_mt7621_DEVICE_.*=y$' .config \
	&& [ "$(grep -c '^CONFIG_TARGET_ramips_mt7621_DEVICE_.*=y$' .config)" -ne 1 ]; then
	echo 'More than one MT7621 device is selected' >&2
	exit 1
fi

echo 'Selected device: qihoo_360t6gs'
