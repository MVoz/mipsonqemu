REM qemu.exe  -L . -m 128 -hda test.img -boot c -net tap,ifname=mytap -net nic,model=rtl8139 -serial file:qemu-output.log
REM qemu.exe  -L . -m 128 -hda test.img -boot c -net tap,ifname=mytap -net nic,model=rtl8139 -serial COM1
qemu.exe  -L . -m 32 -hda test.img -boot c -net tap,ifname=mytap -net nic,model=rtl8139 -serial COM3