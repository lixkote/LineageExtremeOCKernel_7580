#!/bin/bash
export USER_NAME=$(whoami)

export ARCH=arm64
export CROSS_COMPILE=/home/$USER_NAME/UltinageKernel_7580/aarch64-linux-android-4.9/bin/aarch64-linux-android-

export KBUILD_BUILD_USER=UltinageKernel
export KBUILD_BUILD_HOST=Lixkote

mkdir -p output

echo "===> DEFCONFIG"
make -C $(pwd) O=output lineageos_a3xelte_defconfig

echo "===> BUILD"
make -j64 -C $(pwd) O=output
