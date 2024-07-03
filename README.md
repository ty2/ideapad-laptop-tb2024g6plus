# The IdeaPad ACPI Extras kernel modules for ThinkBook 2024 G6+

This kernel module solves problem with laptop turning off after closing the lid.

Tested and works on:

- Thinkbook 2024 16+ IMH with Ubuntu 24.04 with kernel 6.9.3-060903-generic

## Build

Just run:

```shell
make
```

## Usage

### Install via dkms

```shell
sudo make install-dkms
sudo reboot
```

### Uninstall via dkms

```shell
sudo make uninstall-dkms
sudo reboot
```
