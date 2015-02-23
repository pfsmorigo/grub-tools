#!/bin/bash

BASE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TFTP_DIR=$BASE_DIR/tftp

dd if=/dev/urandom of=$TFTP_DIR/test_1MB bs=1024 count=1024
dd if=/dev/urandom of=$TFTP_DIR/test_10MB bs=1024 count=10240
dd if=/dev/urandom of=$TFTP_DIR/test_100MB bs=1024 count=102400
