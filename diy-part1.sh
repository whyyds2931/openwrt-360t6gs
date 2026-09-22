#!/bin/bash
#=================================================
# DIY 脚本 1 - 编译前自定义
# 360 T6GS (MT7621 + MT7915)
#=================================================

# 1. 复制设备 DTS 文件
mkdir -p target/linux/ramips/dts
cp $GITHUB_WORKSPACE/mt7621_qihoo_360t6gs.dts target/linux/ramips/dts/
echo "DTS文件已复制: $(ls -la target/linux/ramips/dts/mt7621_qihoo_360t6gs.dts)"

# 2. 直接用完整的mt7621.mk替换（设备定义在正确位置）
cp $GITHUB_WORKSPACE/mt7621.mk target/linux/ramips/image/mt7621.mk
echo "mk文件已替换，验证设备定义:"
grep -n "qihoo_360t6gs" target/linux/ramips/image/mt7621.mk

# 3. 添加第三方插件源（UA3F + 深澜 + 常用插件）
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default

echo "=== DIY 1 完成 ==="
