#
#	Makefile -- Build instructions for Realtek/RTL8670
#

CONFIGPATH=$(shell pwd)

include $(ROOTDIR)/$(LINUXDIR)/.config
ROMFSIMG = $(IMAGEDIR)/romfs.img
IMAGE    = $(IMAGEDIR)/image.bin
KERNELIMAGE    = $(IMAGEDIR)/kernel.img
ifdef CONFIG_ROMFS_FS
	DEVCMD = for i in $(DEVICES); do \
			touch $(ROMFSDIR)/dev/@$$i; \
		done
	ROMFS_DIRS = bin dev etc home lib mnt proc usr var etc/scripts 
else
	DEVCMD =
	ROMFS_DIRS = bin etc home lib mnt proc usr var etc/scripts 

ifdef CONFIG_USER_FLATFSD_XXX
	ROMFS_DIRS += etc/default
endif

endif

ROMFS_DIRS = bin dev etc home lib proc usr var etc/scripts usr/local usr/local/ct

ifdef CONFIG_DEFAULTS_KERNEL_2_6
	ROMFS_DIRS += sys
endif

DEVICES = \
	tty,c,5,0      console,c,5,1      cua0,c,5,64      cua1,c,5,65  \
	\
	mem,c,1,1      kmem,c,1,2         null,c,1,3       ram0,b,1,0 \
	ram1,b,1,1 \
	\
	ptyp0,c,2,0    ptyp1,c,2,1        ptyp2,c,2,2      ptyp3,c,2,3 \
	ptyp4,c,2,4    ptyp5,c,2,5        ptyp6,c,2,6      ptyp7,c,2,7 \
	ptyp8,c,2,8    ptyp9,c,2,9        ptypa,c,2,10     ptypb,c,2,11 \
	ptypc,c,2,12   ptypd,c,2,13       ptype,c,2,14     ptypf,c,2,15 \
	\
	rom0,b,31,0    rom1,b,31,1        rom2,b,31,2      rom3,b,31,3 \
	rom4,b,31,4    rom5,b,31,5        rom6,b,31,6      rom7,b,31,7 \
	rom8,b,31,8    rom9,b,31,9 \
	\
	tty0,c,4,0     tty1,c,4,1         tty2,c,4,2       tty3,c,4,3 \
	ttyS0,c,4,64   ttyS1,c,4,65 \
	\
	ttyp0,c,3,0    ttyp1,c,3,1        ttyp2,c,3,2      ttyp3,c,3,3 \
	ttyp4,c,3,4    ttyp5,c,3,5        ttyp6,c,3,6      ttyp7,c,3,7 \
	ttyp8,c,3,8    ttyp9,c,3,9        ttypa,c,3,10     ttypb,c,3,11 \
	ttypc,c,3,12   ttypd,c,3,13       ttype,c,3,14     ttypf,c,3,15 \
	\
	mtd0,c,90,0    mtd1,c,90,1        mtd2,c,90,2      mtd3,c,90,3 \
	\
	zero,c,1,5     random,c,1,8       urandom,c,1,9    ppp,c,108,0 \
	\
	adsl0,c,100,0  wlchr,c,13,0


clean:

romfs:
	[ -d $(ROMFSDIR)/$$i ] || mkdir -p $(ROMFSDIR)
	for i in $(ROMFS_DIRS); do \
		[ -d $(ROMFSDIR)/$$i ] || mkdir -p $(ROMFSDIR)/$$i; \
	done
	$(DEVCMD)
	$(ROMFSINST) -s /var/tmp /tmp
	$(ROMFSINST) -s /var/mnt /mnt
	$(ROMFSINST) -s /bin /sbin
	$(ROMFSINST) -s /var/ppp /etc/ppp
	$(ROMFSINST) -s /var/config /etc/config
	$(ROMFSINST) -s /var/passwd /etc/passwd
	$(ROMFSINST) -s /var/TZ /etc/TZ
ifdef CONFIG_DEFAULTS_KERNEL_2_6
	$(ROMFSINST) $(CONFIGPATH)/rc-2.6.x /etc/rc
else
	$(ROMFSINST) /etc/rc
endif

	$(ROMFSINST) -a "echo 10 > /proc/sys/net/ipv4/tcp_keepalive_intvl" /etc/rc
	$(ROMFSINST) -a "echo 3 > /proc/sys/net/ipv4/tcp_keepalive_probes" /etc/rc
	$(ROMFSINST) -a "echo 10 > /proc/sys/net/ipv4/tcp_keepalive_time" /etc/rc

	$(ROMFSINST) /etc/inittab
	echo "console:unknown:/bin/msh" >> $(ROMFSDIR)/etc/inittab
	$(ROMFSINST) /etc/shells
#	$(ROMFSINST) scripts/init.sh /etc/scripts/init.sh
#	$(ROMFSINST) scripts/init-if.sh /etc/scripts/init-if.sh
#	$(ROMFSINST) scripts/init-wan.sh /etc/scripts/init-wan.sh
#	$(ROMFSINST) scripts/adsl-ppp-start.sh /etc/scripts/adsl-ppp-start.sh
#	$(ROMFSINST) scripts/adsl-ppp-close.sh /etc/scripts/adsl-ppp-close.sh
#	$(ROMFSINST) scripts/init-br.sh /etc/scripts/init-br.sh
	
#	$(ROMFSINST) scripts/dhcpc.sh /etc/scripts/dhcpc.sh
#	$(ROMFSINST) scripts/udhcpc.sh /etc/scripts/udhcpc.sh
#	$(ROMFSINST) scripts/udhcpc.bound /etc/scripts/udhcpc.bound
#	$(ROMFSINST) scripts/udhcpc.deconfig /etc/scripts/udhcpc.deconfig
#	$(ROMFSINST) scripts/dhcpd.sh /etc/scripts/dhcpd.sh
	
#	$(ROMFSINST) scripts/firewall.sh /etc/scripts/firewall.sh
#	$(ROMFSINST) scripts/dnsmasq.sh /etc/scripts/dnsmasq.sh
#	$(ROMFSINST) scripts/zebra.sh /etc/scripts/zebra.sh
	
	$(ROMFSINST) services /etc/services
	case "$(LINUXDIR)" in \
	*2.4.*) ;; \
	*2.6.*) ;; \
	*) echo "ttyS0:linux:/bin/sh" >> $(ROMFSDIR)/etc/inittab ;; \
	esac
	$(ROMFSINST) /etc/motd
#	$(ROMFSINST) /bin/busybox
#	$(ROMFSINST) -s /bin/busybox /bin/telnet
#	$(ROMFSINST) -s /bin/busybox /bin/route
#	$(ROMFSINST) -s /bin/busybox /bin/ping
#	$(ROMFSINST) -s /bin/busybox /bin/tftp
#	$(ROMFSINST) -s /bin/busybox /bin/reboot
#	$(ROMFSINST) -s /bin/busybox /bin/uptime
#	$(ROMFSINST) -s /bin/busybox /bin/ifconfig
#	$(ROMFSINST) /etc/passwd
#	$(ROMFSINST) /etc/termcap
#	$(ROMFSINST) /etc/mime.types
#	$(ROMFSINST) /www/index.html
#	$(ROMFSINST) /etc/config/boa.conf
	echo "$(VERSIONSTR) -- " `date` > $(ROMFSDIR)/etc/version
ifdef CONFIG_DEFAULTS_KERNEL_2_6
	$(ROMFSINST) ethertypes /etc/ethertypes
endif
dev:
ifdef CONFIG_SQUASHFS
	[ -d $(ROMFSDIR) ] || mkdir -p $(ROMFSDIR)
	[ -d $(ROMFSDIR)/dev ] || mkdir -p $(ROMFSDIR)/dev
	rm $(ROMFSDIR)/dev/*
	for i in $(DEVICES); do \
		name=`echo $$i |cut -d"," -f1`;\
		type=`echo $$i |cut -d"," -f2`;\
		major=`echo $$i |cut -d"," -f3`;\
		minor=`echo $$i |cut -d"," -f4`;\
		mknod -m644 $(ROMFSDIR)/dev/$$name $$type $$major $$minor;\
	done
endif

image:
	[ -d $(IMAGEDIR) ] || mkdir -p $(IMAGEDIR)
	genromfs -v -V "ROMdisk" -f $(ROMFSIMG) -d $(ROMFSDIR)
	$(CROSS_COMPILE)objcopy -O binary --remove-section=.romvec \
			--remove-section=.text --remove-section=.ramvec \
			--remove-section=.init \
			--remove-section=.bss --remove-section=.eram \
			$(ROOTDIR)/$(LINUXDIR)/linux $(IMAGEDIR)/linux.data
	$(CROSS_COMPILE)objcopy -O binary --remove-section=.ramvec \
			--remove-section=.bss --remove-section=.data \
			--remove-section=.eram \
			--set-section-flags=.romvec=CONTENTS,ALLOC,LOAD,READONLY,CODE \
			$(ROOTDIR)/$(LINUXDIR)/linux $(IMAGEDIR)/linux.text
	cat $(IMAGEDIR)/linux.text $(IMAGEDIR)/linux.data $(ROMFSIMG) > $(IMAGE)
	[ -n "$(NO_BUILD_INTO_TFTPBOOT)" ] || cp $(IMAGE) /tftpboot
	$(CROSS_COMPILE)strip $(ROOTDIR)/$(LINUXDIR)/vmlinux -o $(KERNELIMAGE)

