PWD := $(shell pwd)
KVERSION := $(shell uname -r)
KERNEL_DIR = /lib/modules/$(KVERSION)

MODULE_NAME = ideapad-laptop-tb2024g6plus
MODULE_VERSION = 6.10
MODULE_DIR = $(MODULE_NAME)-$(MODULE_VERSION)

BLACKLIST_MODULE_CONF = blacklist-ideapad-laptop.conf

obj-m := $(MODULE_NAME).o

all:
	make -C $(KERNEL_DIR)/build/ M=$(PWD) modules
clean:
	make -C $(KERNEL_DIR)/build/ M=$(PWD) clean

install:
	sudo insmod ideapad-laptop-tb2024g6plus.ko

install-dkms:
	# Blacklist current ideapad-laptop module
	cp dkms/$(BLACKLIST_MODULE_CONF) /etc/modprobe.d/$(BLACKLIST_MODULE_CONF)
	# Install patched ideapad-laptop module
	install -Dm644 dkms/dkms.conf /usr/src/$(MODULE_DIR)/dkms.conf
	cp -r . /usr/src/$(MODULE_DIR)
	dkms add -m $(MODULE_NAME)/$(MODULE_VERSION)
	dkms install $(MODULE_NAME)/$(MODULE_VERSION)

uninstall-dkms:
	# Delete blacklist for ideapad-laptop module
	rm -f /etc/modprobe.d/$(BLACKLIST_MODULE_CONF)
	# Uninstall patched module
	dkms remove $(MODULE_NAME)/$(MODULE_VERSION) --all
	rm -rf /usr/src/$(MODULE_DIR)

sync-source:
	curl -L -o ideapad-laptop.h https://github.com/torvalds/linux/raw/v6.10/drivers/platform/x86/ideapad-laptop.h
	curl -L -o ideapad-laptop.c https://github.com/torvalds/linux/raw/v6.10/drivers/platform/x86/ideapad-laptop.c
	cp ideapad-laptop.h ideapad-laptop-tb2024g6plus.h
	cp ideapad-laptop.c ideapad-laptop-tb2024g6plus.c

create-patch:
	diff --unified ideapad-laptop.c ideapad-laptop-tb2024g6plus.c > ideapad-laptop.patch

apply-patch:
	patch < ideapad-laptop.patch