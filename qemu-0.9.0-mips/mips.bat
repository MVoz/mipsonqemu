REM Start qemu on windows.
@ECHO OFF

REM SDL_VIDEODRIVER=directx is faster than windib. But keyboard cannot work well.
SET SDL_VIDEODRIVER=windib

REM SDL_AUDIODRIVER=waveout or dsound can be used. Only if QEMU_AUDIO_DRV=sdl.
SET SDL_AUDIODRIVER=dsound

REM QEMU_AUDIO_DRV=dsound or fmod or sdl or none can be used. See qemu -audio-help.
SET QEMU_AUDIO_DRV=dsound

REM QEMU_AUDIO_LOG_TO_MONITOR=1 displays log messages in QEMU monitor.
SET QEMU_AUDIO_LOG_TO_MONITOR=0


REM Ctrl-Alt-3 show you prompt.

REM qemu-system-mips.exe  -L . -m 64 -kernel vmlinux -initrd initrd.img.gz -net nic, -net tap,ifname=openvpn -append "console = tty0 console=ttyS0 load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=60000 rw root=/dev/ram" 
qemu-system-mips.exe  -L . -m 64 -kernel vmlinux.img -initrd romfs.img  -append "console = tty0 console=ttyS0 load_ramdisk=1 prompt_ramdisk=0 ramdisk_size=60000 rw root=/dev/ram"  -S -s -p 1234