# Default to (primary) SD
rootdev=mmcblk0p2

if itest.b *0x28 == 0x02 ; then
	# U-Boot loaded from eMMC or secondary SD so use it for rootfs too
	echo "U-boot loaded from eMMC or secondary SD"
	rootdev=mmcblk1p2
fi

setenv bootargs console=${console} console=tty1 root=/dev/${rootdev} rootwait panic=10 ${extra}

load mmc 0:1 ${fdt_addr_r} ${fdtfile}

if test -e mmc 0:1 /overlays/sun50i-h618-orangepi-zero2w-expansion.dtbo; then

	echo "Applying expansion board overlay ..."

	fdt addr ${fdt_addr_r}
	fdt resize 65536

	load mmc 0:1 ${scriptaddr} /overlays/sun50i-h618-orangepi-zero2w-expansion.dtbo
	fdt apply ${scriptaddr}

fi

load mmc 0:1 ${kernel_addr_r} Image

booti ${kernel_addr_r} - ${fdt_addr_r}
