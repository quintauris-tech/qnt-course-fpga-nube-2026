# NEORV32 bootloader makefile - QUINTAURIS hackathon build
#
# Customized from the upstream NEORV32 bootloader Makefile:
#   - MARCH/MABI set to plain RV32I instead of RV32E, because not every
#     RISC-V toolchain ships the RV32E/ilp32e multilib (this repo was
#     validated with a toolchain that only has RV32I). If your toolchain
#     does have the RV32E multilib, you can switch back to
#     rv32e_zicsr_zifencei / ilp32e to shave off a bit of ROM usage.
#   - AUTO_BOOT_EN=0: the stock bootloader auto-boots 8s after reset if no
#     UART command arrives, which caused unreliable uploads when resetting
#     the board and starting the upload were not perfectly in sync. With
#     this disabled, the bootloader waits for a command indefinitely.
#   - Custom intro banner (see main.c) instead of the default NEORV32 text.
#
# [IMPORTANT] If you ever change AUTO_BOOT_EN or any other USER_FLAGS here,
# remember that USER_FLAGS passed on the `make` command line REPLACES this
# file's USER_FLAGS entirely (it does not append) - always edit this file
# directly instead of overriding USER_FLAGS from the command line, or you
# will silently lose the RAM/ROM base address defsyms below and end up with
# a bootloader that links against the wrong addresses and does not run.

MARCH = rv32i_zicsr_zifencei
MABI = ilp32

# optimize for minimal size
EFFORT = -Os

# sources and includes
APP_SRC += $(wildcard ./*.c) $(wildcard ./hal/source/*.c) $(wildcard petit_fatfs/*.c)
APP_INC += -I . -I ./hal/include -I petit_fatfs

# just use a minimal "ram" size that should be available on any platform configuration
# [IMPORTANT] adjust the base address to your memory layout
USER_FLAGS += \
-Wl,--defsym,__neorv32_ram_size=256 \
-Wl,--defsym,__neorv32_ram_base=0x80000000

# map to boot ROM and define maximum logical ROM size
# [NOTE] the physical BOOTROM size depends on the actual bootloader size
USER_FLAGS += \
-Wl,--defsym,__neorv32_rom_size=16k \
-Wl,--defsym,__neorv32_rom_base=0xFFE00000

# define MAKE_BOOTLOADER for bootloader-specific library optimizations,
# enable link-time-optimization and use routines for function prologue/epilogue
USER_FLAGS += -DMAKE_BOOTLOADER -flto -msave-restore

# disable the 8s auto-boot countdown - wait for a UART command indefinitely
USER_FLAGS += -DAUTO_BOOT_EN=0

# this repo bundles its own copy of the NEORV32 software framework
NEORV32_HOME ?= ../..
include $(NEORV32_HOME)/sw/common/common.mk
