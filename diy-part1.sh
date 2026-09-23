#!/usr/bin/env bash
set -euo pipefail

# Apply the local device overlay to the exact OpenWrt source tree being built.
openwrt_dir="$(pwd)"
workspace_dir="${GITHUB_WORKSPACE:?GITHUB_WORKSPACE is required}"
dts_src="$workspace_dir/mt7621_qihoo_360t6gs.dts"
mk_fragment="$workspace_dir/mt7621.mk"
dts_dst="$openwrt_dir/target/linux/ramips/dts/mt7621_qihoo_360t6gs.dts"
mk_dst="$openwrt_dir/target/linux/ramips/image/mt7621.mk"

test -f "$dts_src"
test -f "$mk_fragment"
test -f "$mk_dst"

mkdir -p "$(dirname "$dts_dst")"
cp "$dts_src" "$dts_dst"

# The parent image Makefile evaluates BuildImage after mt7621.mk is included,
# so the profile belongs at the end of mt7621.mk, not before BuildImage.
sed -i '/^define Device\/qihoo_360t6gs$/,/^TARGET_DEVICES += qihoo_360t6gs$/d' "$mk_dst"
cat "$mk_fragment" >> "$mk_dst"

grep -q '^define Device/qihoo_360t6gs$' "$mk_dst"
grep -q '^TARGET_DEVICES += qihoo_360t6gs$' "$mk_dst"
grep -q '^  DEVICE_DTS := mt7621_qihoo_360t6gs$' "$mk_dst"
test -f "$dts_dst"

if ! grep -q '^src-git kenzo ' feeds.conf.default; then
	printf '%s\n' 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >> feeds.conf.default
fi
if ! grep -q '^src-git small ' feeds.conf.default; then
	printf '%s\n' 'src-git small https://github.com/kenzok8/small' >> feeds.conf.default
fi

echo "Applied qihoo_360t6gs profile and mt7621_qihoo_360t6gs.dts"
