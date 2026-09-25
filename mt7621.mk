# Qihoo 360 T6GS profile for Heleguo/lede.
# The board has 128 MiB NAND, a separate 4 MiB kernel partition, and a UBI
# firmware partition. Keep this fragment before the image BuildImage call.

define Device/qihoo_360t6gs
  $(Device/dsa-migration)
  $(Device/uimage-lzma-loader)
  BLOCKSIZE := 128k
  PAGESIZE := 2048
  KERNEL_SIZE := 4096k
  UBINIZE_OPTS := -E 5
  DEVICE_VENDOR := Qihoo
  DEVICE_MODEL := 360 T6GS
  IMAGE_SIZE := 125000k
  IMAGES += firmware.bin
  IMAGE/firmware.bin := append-kernel | pad-to $$(KERNEL_SIZE) | append-ubi | \
	check-size
  DEVICE_PACKAGES += kmod-mt7915-firmware
endef
TARGET_DEVICES += qihoo_360t6gs
