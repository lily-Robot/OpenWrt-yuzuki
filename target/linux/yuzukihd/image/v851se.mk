define Device/yuzuki_tinyvision
  KERNEL_NAME := zImage
  DEVICE_VENDOR := YuzukiHD
  DEVICE_MODEL := TinyVision
  DEVICE_DTS = sun8i-v851se-tinyvision
  IMAGE/sysupgrade.img.gz := syterkit-img | gzip | append-metadata
endef
TARGET_DEVICES += yuzuki_tinyvision

define Device/yuzuki_tinyvision_aic8800
  KERNEL_NAME := zImage
  DEVICE_VENDOR := YuzukiHD
  DEVICE_MODEL := TinyVision-AIC8800
  DEVICE_DTS = sun8i-v851se-tinyvision-aic8800
  DEVICE_PACKAGES:=kmod-aic8800 aic8800-firmware
  IMAGE/sysupgrade.img.gz := syterkit-img | gzip | append-metadata
endef
TARGET_DEVICES += yuzuki_tinyvision_aic8800
