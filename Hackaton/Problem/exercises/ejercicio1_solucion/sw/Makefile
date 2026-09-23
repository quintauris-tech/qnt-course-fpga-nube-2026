# Application makefile - Knight Rider LED demo for Arty A7.

# Override the default CPU ISA
MARCH = rv32i_zicsr_zifencei

# Override default optimization goal
EFFORT = -Os

# Adjust processor IMEM/DMEM size to match neorv32_arty_top.vhd generics
USER_FLAGS += -Wl,--defsym,__neorv32_rom_size=16k
USER_FLAGS += -Wl,--defsym,__neorv32_ram_size=8k

# This repo bundles its own copy of the NEORV32 software framework
# (sw/common, sw/lib, sw/image_gen) - no external NEORV32 clone needed.
NEORV32_HOME ?= ../../..

include $(NEORV32_HOME)/sw/common/common.mk
