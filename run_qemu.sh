#!/bin/bash

title() {
	echo ""
	echo "------------------------------------ $* ------------------------------------"
}

build() {
	title Build
	cd $SOURCE_DIR && make && make install
}

install() {
	title Install
	cd $BUILD_DIR/bin && ./grub-mknetdir --net-directory=$TFTP_DIR
}

run() {
	title Run
	set -x
	$QEMU $QEMU_OPTIONS -boot order=n -net nic \
		-net user,tftp=$TFTP_DIR,bootfile=$GRUB_CORE \
		-net dump,file=$BASE_DIR/netdump
}

[ -n "$1" ] && NAME=$1 || NAME="code"

BASE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TFTP_DIR=$BASE_DIR/tftp

SOURCE_DIR=$BASE_DIR/$NAME
BUILD_DIR=$BASE_DIR/$NAME-build

QEMU_OPTIONS="-enable-kvm -m 1G"
#QEMU_OPTIONS="-enable-kvm -m 1G -nographic"

case $(uname -m) in
	x86_64)
		QEMU="qemu-system-x86_64"
		GRUB_CORE="/boot/grub/i386-pc/core.0"
		;;
	ppc64le)
		QEMU="qemu-system-ppc64 -M pseries -nodefaults -serial stdio"
		GRUB_CORE="/boot/grub/powerpc-ieee1275/core.elf"
		;;
esac

if [ ! -d "$SOURCE_DIR" ]; then
	echo "Invalid source directory: $SOURCE_DIR"
	exit 1
fi

build || exit 2
install || exit 3
run
