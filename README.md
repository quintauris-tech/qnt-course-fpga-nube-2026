# RISC-V Course: De la nube a la FPGA — 2026

Course materials for the 2026 edition. The 2025 edition is archived separately.

# Prerequisites
## Operating Systems
- Linux 
or
- Windows (with WSL): https://learn.microsoft.com/en-us/windows/wsl/install

## Tools
<!-- TODO 2026: confirm the Vivado edition used this year before publishing. -->
- Vivado - Edition 2025.1: https://www.xilinx.com/support/download.html
- OpenFPGA: https://github.com/lnis-uofu/OpenFPGA
- Putty: https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html

## RISC-V Repositories

To clone:
- NEORV32: https://github.com/stnolting/neorv32
- CVA6 - OpenHW: https://github.com/openhwgroup/cva6

## RISC-V GNU TOOLCHAIN
https://github.com/riscv-collab/riscv-gnu-toolchain

Steps to get the RISCV toolchain
    
    sudo apt-get install autoconf automake autotools-dev curl python3 python3-pip python3-tomli libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build 
    git cmake libglib2.0-dev libslirp-dev
    ./configure --prefix=/opt/riscv --with-arch=rv32ima --with-abi=ilp32 
    make

Note that /opt/riscv needs to be writeable (sudo chmod +777 /opt/riscv).

Add /opt/riscv/bin to your PATH.

This will generate the compiler for bare metal and real time OSes. For linux you need to build using command make linux.

Important: The standard gcc libraries are compiled together with the compiler. For this reason it is important to compile the compiler for the same arc that you will use.

## Other interesting repos:
- PULP Platform: https://github.com/pulp-platform
- VexRiscv: https://github.com/SpinalHDL/VexRiscv
