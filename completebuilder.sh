#!/usr/bin/env bash

set -e

USER_NAME=$(whoami)

KERNEL_DIR="/home/$USER_NAME/UltinageKernel_7580"
AIK_DIR="/home/$USER_NAME/UltinageKernel_7580/AIK-Linux-x32-x64"
OUTPUT_DIR="$KERNEL_DIR/output"
DATE=$(date +%Y-%m-%d_%H-%M-%S)

echo "DATE=$DATE"

echo "===> Cleaning output"
rm -rf "$OUTPUT_DIR"

echo "===> Build kernel"
cd "$KERNEL_DIR"
./build_kernel.sh

echo "===> Build dt.img"
./dtbtool -o "$OUTPUT_DIR/arch/arm64/boot/dt.img" \
-s 2048 \
-p "$OUTPUT_DIR/scripts/dtc/" \
"$OUTPUT_DIR/arch/arm64/boot/dts/" -v

echo "===> Deleting old images if exist"
rm -f "$AIK_DIR/image-new.img"

echo "===> Unpacking boot.img"
cd "$AIK_DIR"
bash ./unpackimg_x64.sh boot.img

echo "===> Copy files"
cp "$OUTPUT_DIR/arch/arm64/boot/dt.img" "$AIK_DIR/split_img/boot.img-dtb"
cp "$OUTPUT_DIR/arch/arm64/boot/Image" "$AIK_DIR/split_img/boot.img-zImage"

echo "===> Repacking"
bash ./repackimg_x64.sh boot.img

echo "===> Checking output"
ls -lah image-new.img

echo "===> Copy final image"
cp image-new.img "/home/$USER_NAME/UltinageKernel_7580/ready_bootimages/bootimg-${DATE}.img"

echo "DONE"
