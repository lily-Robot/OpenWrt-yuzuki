# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2013 OpenWrt.org

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

DEVICE_VARS += UBOOT_DEVICE_NAME

FAT32_BLOCK_SIZE=1024
FAT32_BLOCKS=$(shell echo $$(($(CONFIG_TARGET_KERNEL_PARTSIZE)*1024*1024/$(FAT32_BLOCK_SIZE))))

define Build/syterkit-img
	# Creates the final SD/eMMC images, 
	# combining boot partition, root partition as well as the u-boot bootloader

	rm -f $@.boot
	mkfs.fat $@.boot -C $(FAT32_BLOCKS)

	mcopy -i $@.boot $(DTS_DIR)/$(DEVICE_DTS).dtb ::sunxi.dtb
	mcopy -i $@.boot $(IMAGE_KERNEL) ::zImage
	mcopy -i $@.boot config.txt ::config.txt
	./gen_sunxi_sdcard_img.sh $@ \
		$@.boot \
		$(IMAGE_ROOTFS) \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) \
		$(CONFIG_TARGET_ROOTFS_PARTSIZE) \
		syter_boot_bin_card.bin
	rm -f $@.boot

endef

define Build/uboot-img
	# Creates the final SD/eMMC images, 
	# combining boot partition, root partition as well as the u-boot bootloader

	rm -f $@.boot
	mkfs.fat $@.boot -C $(FAT32_BLOCKS)

	mcopy -i $@.boot $(DTS_DIR)/$(DEVICE_DTS).dtb ::sunxi.dtb
	mcopy -i $@.boot $(IMAGE_KERNEL) ::Image
	mcopy -i $@.boot $(STAGING_DIR_IMAGE)/BoardEnv.txt ::BoardEnv.txt
	mcopy -i $@.boot $(STAGING_DIR_IMAGE)/boot.scr ::boot.scr
	./gen_sunxi_sdcard_img.sh $@ \
		$@.boot \
		$(IMAGE_ROOTFS) \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) \
		$(CONFIG_TARGET_ROOTFS_PARTSIZE) \
		$(STAGING_DIR_IMAGE)/h616-u-boot-with-spl.bin
	rm -f $@.boot

endef

### Devices ###
define Device/Default
  PROFILES := Default
  KERNEL := kernel-bin
  IMAGES := sysupgrade.img.gz
endef

include $(SUBTARGET).mk

$(eval $(call BuildImage))
