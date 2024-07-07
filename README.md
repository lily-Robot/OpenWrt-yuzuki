[ 中文 | [English](https://github.com/YuzukiHD/OpenWrt/blob/openwrt-23.05/README.en.md) ]

# 本仓库基于 OpenWrt

## 注意

1. **不要用 root 用户进行编译**
2. 默认 wan 口启用防火墙

## 支持的设备

1. [TinyVision](https://github.com/YuzukiHD/TinyVision)

## 编译命令

1. 首先装好 Linux 系统，推荐 Debian 11 或 Ubuntu LTS

2. 安装编译依赖

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

3. 下载源代码后更新 feeds 并选择配置

   ```bash
   ./scripts/feeds update -a
   ./scripts/feeds install -a
   make menuconfig
   ```

4. 下载 dl 库，编译固件
（-j 后面是线程数，第一次编译推荐用单线程）

   ```bash
   make download -j$(nproc)
   make V=s -j1
   ```

5. 自定义内核配置（可选）
（需要模块的话需要在 `make menuconfig` 的 `Kernel Modules` 里面勾选，在这里勾选的模块默认不会打包到镜像里）

   ```bash
   make kernel_menuconfig
   ```

编译完成后输出路径：bin/targets

## 特别提醒

1. 本仓库有引用自 [immortalwrt](https://github.com/immortalwrt/immortalwrt) 的相关内容，引用请注明。
