qemu.exe -L . -m 128 -hda test.img -boot c -net tap,ifname=mytap -net nic,model=rtl8139

