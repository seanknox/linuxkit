#!/bin/sh

mkdir -p /tmp/input

cd /tmp/input

tar xf -

find . | cpio -H newc -o | gzip -9 > ../initrd.img

cd /tmp

SIZE=$(stat -c "%s" initrd.img)
SIZE4=$(( $SIZE / 4 \* 4 ))
DIFF=$(( $SIZE - $SIZE4 ))
[ $DIFF -ne 0 ] && DIFF=$(( 4 - $DIFF ))

dd if=/dev/zero bs=1 count=$DIFF of=zeropad

cat zeropad >> initrd.img

SIZE=$(stat -c "%s" initrd.img)
SIZE4=$(( $SIZE / 4 \* 4 )) 
DIFF=$(( $SIZE - $SIZE4 ))

if [ $DIFF -ne 0 ]
then
	echo "Bad alignment" >2
	exit 1
fi

cat initrd.img