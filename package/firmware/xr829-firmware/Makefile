# SPDX-License-Identifier: GPL-2.0-or-later

include $(TOPDIR)/rules.mk

PKG_NAME:=xr829-firmware
PKG_RELEASE:=7

PKG_MAINTAINER:=Yzuki <xxxxxx@gmail.com>

include $(INCLUDE_DIR)/package.mk

define Package/xr829-default
  SECTION:=firmware
  CATEGORY:=Firmware
endef

define Build/Compile
	true
endef

# Cypress 4339 SDIO NVRAM
define Package/xr829-sdio
  $(Package/xr829-default)
  TITLE:=XR829 SDIO Firmware
endef

define Package/xr829-sdio/install
	$(INSTALL_DIR) $(1)/lib/firmware
	$(INSTALL_DATA) ./files/boot_xr829.bin $(1)/lib/firmware/boot_xr829.bin
	$(INSTALL_DATA) ./files/etf_xr829.bin $(1)/lib/firmware/etf_xr829.bin
	$(INSTALL_DATA) ./files/fw_xr829.bin $(1)/lib/firmware/fw_xr829.bin
	$(INSTALL_DATA) ./files/sdd_xr829_40M.bin $(1)/lib/firmware/sdd_xr829.bin
	$(INSTALL_DATA) ./files/fw_xr829_bt_40M.bin $(1)/lib/firmware/fw_xr829_bt.bin
	$(INSTALL_DATA) ./files/xr829.bin $(1)/lib/firmware/xr829.bin

endef

$(eval $(call BuildPackage,xr829-sdio))
