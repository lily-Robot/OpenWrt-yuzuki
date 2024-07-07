#
# Copyright (C) 2013-2016 OpenWrt.org
# Copyright (C) 2017 Yousong Zhou
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_VERSION:=2021.10

PKG_HASH:=4ba1fa478edc57d98b38876b62f7fdf704de27c73b49be6440f4bea6bf589f81

PKG_MAINTAINER:=Zoltan HERPAI <wigyori@uid0.hu>

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

PKG_SOURCE_URL = https://github.com/chainsx/u-boot-h616/releases/download/2021.10/

define U-Boot-H616/Default
  BUILD_TARGET:=yuzukihd
  UBOOT_IMAGE:=u-boot-sunxi-with-spl.bin
  UENV:=default
  HIDDEN:=1
endef

define U-Boot-H616/h616
  BUILD_SUBTARGET:=cortexa53
  NAME:=H616 Devices
  BUILD_DEVICES:=h616_defconfig
  DEPENDS:=+PACKAGE_u-boot-h616-h616:trusted-firmware-a-sunxi-h616
endef

UBOOT_TARGETS := \
	h616

UBOOT_CONFIGURE_VARS += USE_PRIVATE_LIBGCC=yes

UBOOT_MAKE_FLAGS += \
	BL31=$(STAGING_DIR_IMAGE)/bl31_sunxi-h616.bin

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(CP) $(PKG_BUILD_DIR)/$(UBOOT_IMAGE) $(STAGING_DIR_IMAGE)/h616-u-boot-with-spl.bin
	$(CP) sunxi.txt $(STAGING_DIR_IMAGE)/BoardEnv.txt
	mkimage -C none -A arm -T script -d uEnv-h616.txt \
		$(STAGING_DIR_IMAGE)/boot.scr
endef

define Package/u-boot/install/default
endef

$(eval $(call BuildPackage/U-Boot))
