#!/bin/bash
#=================================================
# DIY 脚本 1 - 编译前自定义
# 360 T6GS (MT7621 + MT7915)
#=================================================

# 1. 复制设备 DTS 文件
mkdir -p target/linux/ramips/dts
cp $GITHUB_WORKSPACE/mt7621_qihoo_360t6gs.dts target/linux/ramips/dts/
echo "DTS文件已复制: $(ls -la target/linux/ramips/dts/mt7621_qihoo_360t6gs.dts)"

# 2. 在官方mk文件的BuildImage之前插入360t6gs设备定义
echo "mk文件末尾内容:"
tail -5 target/linux/ramips/image/mt7621.mk

# 在$(eval $(call BuildImage))之前插入设备定义
sed -i '/^\$(eval \$(call BuildImage))/i\
\
define Device/qihoo_360t6gs\
  $(Device/nand)\
  $(Device/uimage-lzma-loader)\
  DEVICE_VENDOR := Qihoo\
  DEVICE_MODEL := 360 T6GS\
  IMAGE_SIZE := 125000k\
  KERNEL_IN_UBI := 1\
  UBINIZE_OPTS := -E 5\
  IMAGES += firmware.bin\
  IMAGE/firmware.bin := append-kernel | pad-to $$(KERNEL_SIZE) | append-ubi | check-size\
  DEVICE_PACKAGES += kmod-mt7915-firmware\
endef\
TARGET_DEVICES += qihoo_360t6gs\
' target/linux/ramips/image/mt7621.mk

echo "设备定义已插入，验证:"
grep -n "qihoo_360t6gs" target/linux/ramips/image/mt7621.mk

# 3. 添加第三方插件源（UA3F + 深澜 + 常用插件）
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default

echo "=== DIY 1 完成 ==="
