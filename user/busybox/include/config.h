/*
 * Automatically generated header file: don't edit
 */

#define AUTOCONF_INCLUDED

/* Version Number */
#define BB_VER "1.00"
#define BB_BT "2009.12.24-01:58+0000"

#define HAVE_DOT_CONFIG 1

/*
 * General Configuration
 */
#define CONFIG_FEATURE_BUFFERS_USE_MALLOC 1
#undef CONFIG_FEATURE_BUFFERS_GO_ON_STACK
#undef CONFIG_FEATURE_BUFFERS_GO_IN_BSS
#undef CONFIG_FEATURE_VERBOSE_USAGE
#undef CONFIG_FEATURE_INSTALLER
#undef CONFIG_LOCALE_SUPPORT
#undef CONFIG_FEATURE_DEVFS
#undef CONFIG_FEATURE_DEVPTS
#undef CONFIG_FEATURE_CLEAN_UP
#undef CONFIG_FEATURE_SUID
#undef CONFIG_SELINUX

/*
 * Build Options
 */
#undef CONFIG_STATIC
#undef CONFIG_LFS
#undef USING_CROSS_COMPILER
#define EXTRA_CFLAGS_OPTIONS ""

/*
 * Installation Options
 */
#undef CONFIG_INSTALL_NO_USR
#define PREFIX "./_install"

/*
 * Archival Utilities
 */
#undef CONFIG_AR
#undef CONFIG_BUNZIP2
#undef CONFIG_CPIO
#undef CONFIG_DPKG
#undef CONFIG_DPKG_DEB
#undef CONFIG_GUNZIP
#undef CONFIG_GZIP
#undef CONFIG_RPM2CPIO
#undef CONFIG_RPM
#undef CONFIG_TAR
#undef CONFIG_UNCOMPRESS
#undef CONFIG_UNZIP

/*
 * Coreutils
 */
#define CONFIG_BASENAME 1
#undef CONFIG_CAL
#undef CONFIG_CAT
#undef CONFIG_CHGRP
#undef CONFIG_CHMOD
#undef CONFIG_CHOWN
#undef CONFIG_CHROOT
#undef CONFIG_CMP
#undef CONFIG_CP
#undef CONFIG_CUT
#define CONFIG_DATE 1
#undef CONFIG_FEATURE_DATE_ISOFMT
#undef CONFIG_DD
#undef CONFIG_DF
#undef CONFIG_DIRNAME
#undef CONFIG_DOS2UNIX
#define CONFIG_DU 1
#undef CONFIG_FEATURE_DU_DEFALT_BLOCKSIZE_1K
#undef CONFIG_ECHO
#undef CONFIG_ENV
#undef CONFIG_EXPR
#define CONFIG_FALSE 1

/*
 * false (forced enabled for use with shell)
 */
#undef CONFIG_FOLD
#undef CONFIG_HEAD
#undef CONFIG_HOSTID
#undef CONFIG_ID
#undef CONFIG_INSTALL
#undef CONFIG_LENGTH
#undef CONFIG_LN
#undef CONFIG_LOGNAME
#define CONFIG_LS 1
#undef CONFIG_FEATURE_LS_FILETYPES
#undef CONFIG_FEATURE_LS_FOLLOWLINKS
#undef CONFIG_FEATURE_LS_RECURSIVE
#undef CONFIG_FEATURE_LS_SORTFILES
#undef CONFIG_FEATURE_LS_TIMESTAMPS
#undef CONFIG_FEATURE_LS_USERNAME
#undef CONFIG_FEATURE_LS_COLOR
#undef CONFIG_MD5SUM
#undef CONFIG_MKDIR
#undef CONFIG_MKFIFO
#undef CONFIG_MKNOD
#undef CONFIG_MV
#undef CONFIG_OD
#undef CONFIG_PRINTF
#undef CONFIG_PWD
#undef CONFIG_REALPATH
#undef CONFIG_RM
#undef CONFIG_RMDIR
#undef CONFIG_SEQ
#undef CONFIG_SHA1SUM
#undef CONFIG_SLEEP
#undef CONFIG_SORT
#undef CONFIG_STTY
#undef CONFIG_SYNC
#undef CONFIG_TAIL
#undef CONFIG_TEE
#define CONFIG_TEST 1

/*
 * test (forced enabled for use with shell)
 */
#undef CONFIG_FEATURE_TEST_64
#undef CONFIG_TOUCH
#undef CONFIG_TR
#define CONFIG_TRUE 1

/*
 * true (forced enabled for use with shell)
 */
#undef CONFIG_TTY
#undef CONFIG_UNAME
#undef CONFIG_UNIQ
#undef CONFIG_USLEEP
#undef CONFIG_UUDECODE
#undef CONFIG_UUENCODE
#undef CONFIG_WATCH
#undef CONFIG_WC
#undef CONFIG_WHO
#undef CONFIG_WHOAMI
#undef CONFIG_YES

/*
 * Common options for ls and more
 */
#undef CONFIG_FEATURE_AUTOWIDTH

/*
 * Common options for df, du, ls
 */
#undef CONFIG_FEATURE_HUMAN_READABLE

/*
 * Console Utilities
 */
#undef CONFIG_CHVT
#undef CONFIG_CLEAR
#undef CONFIG_DEALLOCVT
#undef CONFIG_DUMPKMAP
#undef CONFIG_LOADFONT
#undef CONFIG_LOADKMAP
#undef CONFIG_OPENVT
#undef CONFIG_RESET
#undef CONFIG_SETKEYCODES

/*
 * Debian Utilities
 */
#undef CONFIG_MKTEMP
#undef CONFIG_PIPE_PROGRESS
#undef CONFIG_READLINK
#undef CONFIG_RUN_PARTS
#undef CONFIG_START_STOP_DAEMON
#undef CONFIG_WHICH

/*
 * Editors
 */
#undef CONFIG_AWK
#undef CONFIG_PATCH
#undef CONFIG_SED
#undef CONFIG_VI

/*
 * Finding Utilities
 */
#undef CONFIG_FIND
#undef CONFIG_GREP
#undef CONFIG_XARGS

/*
 * Init Utilities
 */
#undef CONFIG_INIT
#undef CONFIG_HALT
#undef CONFIG_POWEROFF
#undef CONFIG_REBOOT
#undef CONFIG_MESG

/*
 * Login/Password Management Utilities
 */
#undef CONFIG_USE_BB_PWD_GRP
#undef CONFIG_ADDGROUP
#undef CONFIG_DELGROUP
#undef CONFIG_ADDUSER
#undef CONFIG_DELUSER
#undef CONFIG_GETTY
#undef CONFIG_LOGIN
#undef CONFIG_PASSWD
#undef CONFIG_SU
#undef CONFIG_SULOGIN
#undef CONFIG_VLOCK

/*
 * Miscellaneous Utilities
 */
#undef CONFIG_ADJTIMEX
#undef CONFIG_CROND
#undef CONFIG_CRONTAB
#undef CONFIG_DC
#undef CONFIG_DEVFSD
#undef CONFIG_LAST
#undef CONFIG_HDPARM
#undef CONFIG_MAKEDEVS
#undef CONFIG_MT
#undef CONFIG_RX
#undef CONFIG_STRINGS
#undef CONFIG_TIME
#undef CONFIG_WATCHDOGD

/*
 * Linux Module Utilities
 */
#undef CONFIG_INSMOD
#undef CONFIG_LSMOD
#undef CONFIG_MODPROBE
#undef CONFIG_RMMOD

/*
 * Networking Utilities
 */
#undef CONFIG_FEATURE_IPV6
#undef CONFIG_ARPING
#undef CONFIG_FTPGET
#undef CONFIG_FTPPUT
#define CONFIG_HOSTNAME 1
#undef CONFIG_HTTPD
#undef CONFIG_IFCONFIG
#undef CONFIG_IFUPDOWN
#undef CONFIG_INETD
#undef CONFIG_IP
#undef CONFIG_IPCALC
#undef CONFIG_IPADDR
#undef CONFIG_IPLINK
#undef CONFIG_IPROUTE
#undef CONFIG_IPTUNNEL
#undef CONFIG_NAMEIF
#undef CONFIG_NC
#undef CONFIG_NETSTAT
#undef CONFIG_NSLOOKUP
#undef CONFIG_PING
#define CONFIG_ROUTE 1
#undef CONFIG_TELNET
#undef CONFIG_TELNETD
#undef CONFIG_TFTP
#undef CONFIG_TRACEROUTE
#undef CONFIG_VCONFIG
#undef CONFIG_WGET

/*
 * udhcp Server/Client
 */
#undef CONFIG_UDHCPD
#undef CONFIG_UDHCPC

/*
 * Process Utilities
 */
#undef CONFIG_FREE
#undef CONFIG_KILL
#undef CONFIG_PIDOF
#undef CONFIG_PS
#undef CONFIG_RENICE
#undef CONFIG_TOP
#define CONFIG_UPTIME 1
#undef CONFIG_SYSCTL

/*
 * Another Bourne-like Shell
 */
#undef CONFIG_FEATURE_SH_IS_ASH
#undef CONFIG_FEATURE_SH_IS_HUSH
#undef CONFIG_FEATURE_SH_IS_LASH
#define CONFIG_FEATURE_SH_IS_MSH 1
#undef CONFIG_FEATURE_SH_IS_NONE
#undef CONFIG_ASH
#undef CONFIG_HUSH
#undef CONFIG_LASH
#define CONFIG_MSH 1

/*
 * Bourne Shell Options
 */
#undef CONFIG_FEATURE_SH_EXTRA_QUIET
#undef CONFIG_FEATURE_SH_STANDALONE_SHELL
#undef CONFIG_FEATURE_COMMAND_EDITING

/*
 * System Logging Utilities
 */
#undef CONFIG_SYSLOGD
#undef CONFIG_LOGGER

/*
 * Linux System Utilities
 */
#define CONFIG_DMESG 1
#undef CONFIG_FBSET
#undef CONFIG_FDFLUSH
#undef CONFIG_FDFORMAT
#undef CONFIG_FDISK
#undef CONFIG_FREERAMDISK
#undef CONFIG_FSCK_MINIX
#undef CONFIG_MKFS_MINIX
#undef CONFIG_GETOPT
#undef CONFIG_HEXDUMP
#undef CONFIG_HWCLOCK
#undef CONFIG_LOSETUP
#undef CONFIG_MKSWAP
#undef CONFIG_MORE
#undef CONFIG_PIVOT_ROOT
#undef CONFIG_RDATE
#undef CONFIG_SWAPONOFF
#define CONFIG_MOUNT 1
#undef CONFIG_NFSMOUNT
#define CONFIG_UMOUNT 1
#undef CONFIG_FEATURE_MOUNT_FORCE

/*
 * Common options for mount/umount
 */
#undef CONFIG_FEATURE_MOUNT_LOOP
#undef CONFIG_FEATURE_MTAB_SUPPORT

/*
 * Debugging Options
 */
#undef CONFIG_DEBUG
