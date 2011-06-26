REM qemu.exe  -L . -m 128 -hda test.img -boot c -net tap,ifname=mytap -net nic,model=rtl8139 -serial file:qemu-output.log
REM qemu.exe  -L . -m 128 -hda test.img -boot c -net tap,ifname=mytap -net nic,model=rtl8139 -serial COM1
REM qemu.exe  -L . -m 32 -hda test.img -boot c -net tap,ifname=mytap1 -net nic,modle=rtl8139 -net tap,ifname=mytap2 -net nic -serial COM3
qemu.exe  -L . -m 32 -hda test.img -boot c -net tap,ifname=mytap1 -net nic,modle=rtl8139 -serial COM3