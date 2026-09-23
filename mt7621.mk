# Native ImmortalWrt/OpenWrt profile for the 360 T6GS.
# The device uses a 16 MiB SPI-NOR flash, not NAND/UBI.

define Device/360_360t6gs
  $(Device/dsa-migration)
  IMAGE_SIZE := 15872k
  DEVICE_VENDOR := 360
  DEVICE_MODEL := 360T6GS
  DEVICE_PACKAGES := kmod-mt7915e kmod-mt7915-firmware -uboot-envtools
endef
TARGET_DEVICES += 360_360t6gs
