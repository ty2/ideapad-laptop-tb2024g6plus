PWD := $(shell pwd)
KVERSION := $(shell uname -r)
KERNEL_DIR = /lib/modules/$(KVERSION)

MODULE_NAME = ideapad-laptop-tb2024g6plus
obj-m := $(MODULE_NAME).o

all:
	make -C $(KERNEL_DIR)/build/ M=$(PWD) modules
clean:
	make -C $(KERNEL_DIR)/build/ M=$(PWD) clean

install:
	sudo insmod ideapad-laptop-tb2024g6plus.ko

sync-source:
	curl -L -o ideapad-laptop.h https://github.com/torvalds/linux/raw/v6.9/drivers/platform/x86/ideapad-laptop.h
	curl -L -o ideapad-laptop.c https://github.com/torvalds/linux/raw/v6.9/drivers/platform/x86/ideapad-laptop.c
	cp ideapad-laptop.h ideapad-laptop-tb2024g6plus.h
	cp ideapad-laptop.c ideapad-laptop-tb2024g6plus.c

create-patch:
	diff --unified ideapad-laptop.c ideapad-laptop-tb2024g6plus.c > ideapad-laptop.patch

apply-patch:
	patch < ideapad-laptop.patch