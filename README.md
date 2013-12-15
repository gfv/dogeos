DogeOS
======

DogeOS. It has Doge. Wow.

Build requirements
------------------
* ```fasm``` -- I use 1.70.03 but I'm pretty sure I don't use any version-specific stuff.
* ```gcc``` -- again, I use 4.7, but C code is likely c99-compatible, so likely any recent Intel-targeted gcc or clang will do.
* ```binutils``` -- 2.23.1, but again, anything good enough to build stuff on i386/amd64 platform with ELF support should work.
* ```qemu``` built with i386/amd64 system emulation support -- DogeOS works quite nicely.

Instructions
------------
DogeOS compiles to a multiboot-compatible kernel, mosly because I was too lazy to switch to protected mode manually and implement any kind of multistaged bootloader -- I figured GRUB can do all that stuff for me.

Just use ```make``` to build the kernel. This will generate a file (unimaginatively) called ```kernel``` beside sources. You may run ```make test``` to try it out with ```qemu-system-i386 -kernel kernel``` or copy it to your /boot and point GRUB to it with something along the lines of ```kernel /boot/doge-kernel``` -- figure it out, it's not exactly rocket science.
