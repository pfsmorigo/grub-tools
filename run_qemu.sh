#!/bin/bash -e

SOURCE_DIR=$HOME/projects/grub/debug
BUILD_DIR=$HOME/projects/grub/debug-build
TFTP_DIR=$HOME/projects/grub/tftp

case $(uname -m) in
	ppc64le)
		QEMU="qemu-system-ppc64 -M pseries -nodefaults -serial stdio"
		GRUB_CORE="/boot/grub/powerpc-ieee1275/core.elf"
		;;
	x86_64)
		QEMU="qemu-system-x86_64"
		GRUB_CORE="/boot/grub/i386-pc/core.0"
		;;
esac

echo "------------------------------------ Build ------------------------------------"
cd $SOURCE_DIR && make && make install

echo "----------------------------------- Install -----------------------------------"
cd $BUILD_DIR/bin && ./grub-mknetdir --net-directory=$TFTP_DIR

echo "------------------------------------- Run -------------------------------------"
set -x
$QEMU -enable-kvm -m 1G -nographic -boot order=n -net nic \
	-net user,tftp=$TFTP_DIR,bootfile=$GRUB_CORE
