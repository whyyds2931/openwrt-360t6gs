#!/usr/bin/env bash
set -euo pipefail

# Add the board definition to the official OpenWrt source tree.
openwrt_dir="$(pwd)"
workspace_dir="${GITHUB_WORKSPACE:?GITHUB_WORKSPACE is required}"
dts_src="$workspace_dir/mt7621_qihoo_360t6gs.dts"
dts_dst="$openwrt_dir/target/linux/ramips/dts/mt7621_360_360t6gs.dts"
mk_src="$workspace_dir/mt7621.mk"
mk_dst="$openwrt_dir/target/linux/ramips/image/mt7621.mk"

test -f "$dts_src"
test -f "$mk_src"
test -f "$mk_dst"

cp "$dts_src" "$dts_dst"
sed -i '/^define Device\/360_360t6gs$/,/^TARGET_DEVICES += 360_360t6gs$/d' "$mk_dst"
cat "$mk_src" >> "$mk_dst"

grep -q '^define Device\/360_360t6gs$' "$mk_dst"
grep -q '^TARGET_DEVICES += 360_360t6gs$' "$mk_dst"
grep -q 'compatible = "360,360t6gs", "mediatek,mt7621-soc";' "$dts_dst"
grep -q 'compatible = "jedec,spi-nor";' "$dts_dst"
grep -q 'label = "firmware";' "$dts_dst"
! grep -q '&nand' "$dts_dst"

# Keep official feeds and add only the feeds providing the requested apps.
if ! grep -q '^src-git kenzo ' "$openwrt_dir/feeds.conf.default"; then
	printf '%s\n' 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >> "$openwrt_dir/feeds.conf.default"
fi
if ! grep -q '^src-git small ' "$openwrt_dir/feeds.conf.default"; then
	printf '%s\n' 'src-git small https://github.com/kenzok8/small' >> "$openwrt_dir/feeds.conf.default"
fi

echo "Verified official OpenWrt target: 360_360t6gs"
echo "Installed DTS: $dts_dst"
