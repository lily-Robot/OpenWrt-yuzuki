define Device/yuzuki_chameleon
  KERNEL_NAME := Image
  DEVICE_VENDOR := YuzukiHD
  DEVICE_MODEL := Chameleon
  DEVICE_DTS = allwinner/sun50i-h616-yuzukichameleon
  IMAGE/sysupgrade.img.gz := uboot-img | gzip | append-metadata
endef
TARGET_DEVICES += yuzuki_chameleon
