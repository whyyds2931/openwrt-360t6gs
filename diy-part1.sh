#!/usr/bin/env bash
set -euo pipefail

# Install the board DTS and place the profile where the selected source tree
# consumes it. Official OpenWrt needs the pre-BuildImage position; Heleguo's
# split mt7621.mk is safe to append because image/Makefile includes it later.
workspace_dir="${GITHUB_WORKSPACE:?GITHUB_WORKSPACE is required}"
dts_src="$workspace_dir/mt7621_qihoo_360t6gs.dts"
mk_src="$workspace_dir/mt7621.mk"
dts_dst="target/linux/ramips/dts/mt7621_qihoo_360t6gs.dts"
mk_dst="target/linux/ramips/image/mt7621.mk"

test -f "$dts_src"
test -f "$mk_src"
test -f "$mk_dst"

install -Dm0644 "$dts_src" "$dts_dst"

python3 - "$mk_dst" "$mk_src" <<'PY'
from pathlib import Path
import sys

target = Path(sys.argv[1])
fragment = Path(sys.argv[2]).read_text()
source = target.read_text()
start = source.find("define Device/qihoo_360t6gs")
while start >= 0:
    end_marker = "TARGET_DEVICES += qihoo_360t6gs"
    end = source.find(end_marker, start)
    if end < 0:
        raise SystemExit("incomplete existing qihoo_360t6gs profile")
    source = source[:start] + source[end + len(end_marker):]
    start = source.find("define Device/qihoo_360t6gs")

anchor = "$(eval $(call BuildImage))"
pos = source.rfind(anchor)
if pos >= 0:
    source = source[:pos] + "\n" + fragment.rstrip() + "\n\n" + source[pos:]
else:
    # Heleguo/lede includes mt7621.mk from image/Makefile, so the profile
    # must be appended to this subtarget file rather than image/Makefile.
    source = source.rstrip() + "\n\n" + fragment.rstrip() + "\n"

target.write_text(source)
PY

grep -q '^define Device/qihoo_360t6gs$' "$mk_dst"
grep -q '^TARGET_DEVICES += qihoo_360t6gs$' "$mk_dst"
grep -q 'IMAGE_SIZE := 125000k' "$mk_dst"
grep -q 'BLOCKSIZE := 128k' "$mk_dst"
grep -q 'compatible = "qihoo,360t6gs", "mediatek,mt7621-soc";' "$dts_dst"
grep -q '^&nand {' "$dts_dst"
grep -q 'label = "firmware";' "$dts_dst"
! grep -q 'jedec,spi-nor' "$dts_dst"
! grep -q '360_360t6gs' "$mk_dst"

echo "Verified NAND target: qihoo_360t6gs"
echo "DTS: $dts_dst"
