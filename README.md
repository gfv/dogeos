DogeOS
======

DogeOS. It has Doge. Wow.

Build requirements
------------------
* ```fasm``` -- I use 1.70.03 but I don't think that older versions will not work.
* ```gcc``` -- again, I use 4.7, but C code is likely c99-compatible, so probably any recent (>2006? 1999) Intel-targeted
* ```binutils``` -- 2.23.1, but again, anything good enough to build stuff on i*86 should work
* ```qemu``` -- for testiing.

Instructions
------------
DogeOS compiles to a multiboot-compatible kernel, without any hard disk drivers or whatever. Just do ```make``` to build a kernel
or ```make test``` to make and launch QEMU with it.
