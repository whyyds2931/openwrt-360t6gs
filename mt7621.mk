# Qihoo 360 T6GS profile for OpenWrt 23.05.
#
# This is an overlay fragment, not a replacement for the upstream device
# table. diy-part1.sh appends it to target/linux/ramips/image/mt7621.mk
# after removing any previous copy of this profile.

define Device/qihoo_360t6gs
  $(Device/nand)
  $(Device/uimage-lzma-loader)
  DEVICE_VENDOR := Qihoo
  DEVICE_MODEL := 360 T6GS
  DEVICE_DTS := mt7621_qihoo_360t6gs
  IMAGE_SIZE := 125000k
  KERNEL_IN_UBI := 1
  IMAGES += firmware.bin
  IMAGE/firmware.bin := append-kernel | pad-to $$(KERNEL_SIZE) | append-ubi | \
	check-size
  DEVICE_PACKAGES := kmod-mt7915-firmware
endef
TARGET_DEVICES += qihoo_360t6gs

