#!/bin/sh

# set -x

CLASS=rndis
VID=0x3346
PID=0x1003
CONFIG_DIR=/sys/kernel/config
YUZU_GADGET=$CONFIG_DIR/usb_gadget/YuzukiHD
YUZU_FUNC=$YUZU_GADGET/functions
MSC_FILE=$3
FUNC_NUM=0
MAX_EP_NUM=4
TMP_NUM=0
INTF_NUM=0
EP_IN=0
EP_OUT=0

case "$2" in
  msc)
	CLASS=mass_storage
	PID=$MSC_PID
	;;
  rndis)
	CLASS=rndis
	PID=$RNDIS_PID
	PRODUCT=$PRODUCT_RNDIS
	;;
  adb)
	CLASS=ffs.adb
	VID=$ADB_VID
	PID=$ADB_PID
	PRODUCT=$PRODUCT_ADB
	;;
  *)
	if [ "$1" = "probe" ] ; then
	  echo "Usage: $0 probe {msc|rndis|adb| {file (msc)}"
	  exit 1
	fi
esac

calc_func() {
  FUNC_NUM=$(ls $YUZU_GADGET/functions -l | grep ^d | wc -l)
  echo "$FUNC_NUM file(s)"
}

res_check() {
  TMP_NUM=$(find $YUZU_GADGET/functions/ -name "mass_storage*" | wc -l)
  EP_IN=$(($EP_IN+$TMP_NUM))
  EP_OUT=$(($EP_OUT+$TMP_NUM))
  INTF_NUM=$(($INTF_NUM+$TMP_NUM))
  TMP_NUM=$(find $YUZU_GADGET/functions/ -name "rndis*" | wc -l)
  EP_OUT=$(($EP_OUT+$TMP_NUM))
  TMP_NUM=$(($TMP_NUM * 2))
  EP_IN=$(($EP_IN+$TMP_NUM))
  INTF_NUM=$(($INTF_NUM+$TMP_NUM))

  if [ "$CLASS" = "mass_storage" ] ; then
    EP_IN=$(($EP_IN+1))
    EP_OUT=$(($EP_OUT+1))
  fi
  if [ "$CLASS" = "rndis" ] ; then
    EP_IN=$(($EP_IN+2))
    EP_OUT=$(($EP_OUT+1))
  fi
  echo "$EP_IN in ep"
  echo "$EP_OUT out ep"
  if [ $EP_IN -gt $MAX_EP_NUM ]; then
    echo "reach maximum resource"
    exit 1
  fi
  if [ $EP_OUT -gt $MAX_EP_NUM ]; then
    echo "reach maximum resource"
    exit 1
  fi
}

probe() {
  if [ ! -d $CONFIG_DIR ]; then
    mkdir $CONFIG_DIR
  fi
  if [ ! -d $CONFIG_DIR/usb_gadget ]; then
    # Enale USB ConfigFS
    mount none $CONFIG_DIR -t configfs
    # Create gadget dev
    mkdir $YUZU_GADGET
    # Set the VID and PID
    echo $VID > $YUZU_GADGET/idVendor
    echo $PID > $YUZU_GADGET/idProduct
    # Set the product information string
    mkdir $YUZU_GADGET/strings/0x409
    echo "YuzukiHD">$YUZU_GADGET/strings/0x409/manufacturer
    echo "RNDIS">$YUZU_GADGET/strings/0x409/product
    echo "114514">$YUZU_GADGET/strings/0x409/serialnumber
    # Set the USB configuration
    mkdir $YUZU_GADGET/configs/c.1
    mkdir $YUZU_GADGET/configs/c.1/strings/0x409
    echo "RNDIS Config">$YUZU_GADGET/configs/c.1/strings/0x409/configuration
    # Set the MaxPower of USB descriptor
    echo 120 >$YUZU_GADGET/configs/c.1/MaxPower
    # get current functions number
    calc_func
    # resource check
    res_check
    # create the desired function
    mkdir $YUZU_GADGET/functions/$CLASS.usb$FUNC_NUM
    if [ "$CLASS" = "rndis" ] ; then
      #OS STRING
      echo 1 >$YUZU_GADGET/os_desc/use
      echo 0xcd >$YUZU_GADGET/os_desc/b_vendor_code
      echo MSFT100 >$YUZU_GADGET/os_desc/qw_sign
      #COMPATIBLE ID
      echo RNDIS >$YUZU_FUNC/rndis.usb$FUNC_NUM/os_desc/interface.rndis/compatible_id
      #MAKE c.1 THE ONE ASSOCIATED WITH OS DESCRIPTORS
      ln -s $YUZU_GADGET/configs/c.1 $YUZU_GADGET/os_desc
      #MAKE "Icons" EXTENDED PROPERTY
      mkdir $YUZU_FUNC/rndis.usb$FUNC_NUM/os_desc/interface.rndis/Icons
      echo 2 >$YUZU_FUNC/rndis.usb$FUNC_NUM/os_desc/interface.rndis/Icons/type
      echo "%SystemRoot%\\system32\\shell32.dll,-233" >$YUZU_FUNC/rndis.usb$FUNC_NUM/os_desc/interface.rndis/Icons/data
      #MAKE "Label" EXTENDED PROPERTY
      mkdir $YUZU_FUNC/rndis.usb$FUNC_NUM/os_desc/interface.rndis/Label
      echo 1 >$YUZU_FUNC/rndis.usb$FUNC_NUM/os_desc/interface.rndis/Label/type
      echo "XYZ Device" >$YUZU_FUNC/rndis.usb$FUNC_NUM/os_desc/interface.rndis/Label/data
    fi
  fi
}

start() {
  # link this function to the configuration
  calc_func
  if [ $FUNC_NUM -eq 0 ]; then
    echo "Functions Empty!"
    exit 1
  fi
  for i in `seq 0 $(($FUNC_NUM-1))`;
  do
    find $YUZU_GADGET/functions/ -name "*.usb$i" | xargs -I % ln -s % $YUZU_GADGET/configs/c.1
  done
  # Start the gadget driver
  UDC=`ls /sys/class/udc/ | awk '{print $1}'`
  echo ${UDC} >$YUZU_GADGET/UDC
}

stop() {
  if [ -d $YUZU_GADGET/configs/c.1/ffs.adb ]; then
    pkill adbd
    rm $YUZU_GADGET/configs/c.1/ffs.adb
  else
    echo "" >$YUZU_GADGET/UDC
  fi
  find $YUZU_GADGET/configs/ -name "*.usb*" | xargs rm -f
  rmdir $YUZU_GADGET/configs/c.*/strings/0x409/
  tmp_dirs=$(find $YUZU_GADGET/os_desc/c.* -type d)
  if [ -n tmp_dirs ]; then
    echo "remove os_desc!"
    rm -rf $YUZU_GADGET/os_desc/c.*/
    find $YUZU_GADGET/functions/ -name Icons | xargs rmdir
    find $YUZU_GADGET/functions/ -name Label | xargs rmdir
  fi
  rmdir $YUZU_GADGET/configs/c.*/
  rmdir $YUZU_GADGET/functions/*
  rmdir $YUZU_GADGET/strings/0x409/
  rmdir $YUZU_GADGET
  umount $CONFIG_DIR
  rmdir $CONFIG_DIR
}

case "$1" in
  start)
	start
	;;
  stop)
	stop
	;;
  probe)
	probe
	;;
  *)
	echo "Usage: $0 probe {msc|rndis|adb| {file (msc)}"
	echo "Usage: $0 start"
	echo "Usage: $0 stop"
	exit 1
esac
exit $?
