#!/usr/bin/env bash
set -euo pipefail

# Use the native 360_360t6gs target from the ImmortalWrt source tree.
# Only install the board DTS under the name expected by that target.
openwrt_dir="$(pwd)"
workspace_dir="${GITHUB_WORKSPACE:?GITHUB_WORKSPACE is required}"
dts_src="$workspace_dir/mt7621_qihoo_360t6gs.dts"
dts_dst="$openwrt_dir/target/linux/ramips/dts/mt7621_360_360t6gs.dts"

test -f "$dts_src"
test -f "$openwrt_dir/target/linux/ramips/image/mt7621.mk"
grep -q '^define Device/360_360t6gs$' "$openwrt_dir/target/linux/ramips/image/mt7621.mk"
grep -q '^TARGET_DEVICES += 360_360t6gs$' "$openwrt_dir/target/linux/ramips/image/mt7621.mk"

cp "$dts_src" "$dts_dst"
grep -q 'compatible = "360,360t6gs", "mediatek,mt7621-soc";' "$dts_dst"
grep -q 'compatible = "jedec,spi-nor";' "$dts_dst"
grep -q 'label = "firmware";' "$dts_dst"
! grep -q '&nand' "$dts_dst"

echo "Verified native target: 360_360t6gs"
echo "Installed DTS: $dts_dst"
