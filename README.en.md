[ English | [中文](https://github.com/YuzukiHD/OpenWrt/blob/openwrt-23.05/README.md) ]

# This repository is based on OpenWrt

## Note

1. **Do not compile as root user**
2. Firewall is enabled by default on the WAN interface

## Compilation Commands

1. First, install a Linux system, Debian 11 or Ubuntu LTS is recommended

2. Install compilation dependencies

   ```bash
   sudo apt update -y
   sudo apt full-upgrade -y
   sudo apt install -y ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
   bzip2 ccache cmake cpio curl device-tree-compiler fastjar flex gawk gettext gcc-multilib g++-multilib \
   git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libglib2.0-dev libgmp3-dev libltdl-dev \
   libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libreadline-dev libssl-dev libtool lrzsz \
   mkisofs msmtp nano ninja-build p7zip p7zip-full patch pkgconf python2.7 python3 python3-pyelftools \
   libpython3-dev qemu-utils rsync scons squashfs-tools subversion swig texinfo uglifyjs upx-ucl unzip \
   vim wget xmlto xxd zlib1g-dev
   ```

3. Download the source code and update feeds, then select the configuration

   ```bash
   ./scripts/feeds update -a
   ./scripts/feeds install -a
   make menuconfig
   ```

4. Download the dl libraries and compile the firmware
   (-j is followed by the number of threads, for the first compilation, it is recommended to use a single thread)

   ```bash
   make download -j$(nproc)
   make V=s -j1
   ```

5. Customize kernel configuration (optional)
   (If you need modules, you need to select them in `Kernel Modules` in `make menuconfig`. The modules selected here will not be included in the image by default)

   ```bash
   make kernel_menuconfig
   ```

The output path after compilation is: bin/targets

## Special Reminder

1. This repository includes content referenced from [immortalwrt](https://github.com/immortalwrt/immortalwrt). Please indicate the reference when using it.
