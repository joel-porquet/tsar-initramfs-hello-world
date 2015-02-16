KERNEL_BASE?=../linux
KERNEL_USR=$(KERNEL_BASE)/usr
KERNEL_INCLUDE=$(KERNEL_USR)/include

CT_PREFIX?=mipsel-unknown-elf-
CC=$(CT_PREFIX)gcc
LD=$(CT_PREFIX)ld

CFLAGS=-O2 \
       -I$(KERNEL_INCLUDE) \
       -mips32 -mabi=32 \
       -mno-branch-likely -fno-pic -mno-abicalls \
       -EL -D__MIPSEL__ \
       -G0 \
       -msoft-float

hello: hello.o
	$(LD) -G0 -static -nostdlib -o $@ $<

hello.o: hello.S
	$(CC) -c $(CFLAGS) -D__ASSEMBLY__ -o $@ $<

install: initramfs_list hello
	$(KERNEL_USR)/gen_init_cpio $< > $(KERNEL_USR)/initramfs_data.cpio

clean:
	-rm hello hello.o
