# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2013-2014 OpenWrt.org

include $(TOPDIR)/rules.mk

BOARD:=yuzukihd
BOARDNAME:=YuzukiHD Boards
FEATURES:=audio gpio usb usbgadget squashfs targz nand boot-part rootfs-part
SUBTARGETS:=v851se h616

KERNEL_PATCHVER:=5.15

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += uboot-envtools
DEFAULT_PACKAGES += partx-utils mkf2fs e2fsprogs blkid

$(eval $(call BuildTarget))
