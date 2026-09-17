# ================================================================================ #
# NEORV32 on Digilent Arty A7-100T - Constraints (HACKATHON EXERCISE 2)            #
# Target part: xc7a100tcsg324-1                                                    #
#                                                                                   #
# This exercise has no LEDs or buttons - only clock, reset and UART, already       #
# fully constrained below. Nothing to fix here; the exercise is entirely in        #
# src/neorv32_arty_top.vhd (CPU ISA extension generics).                           #
# ================================================================================ #

## ---------------------------------------------------------------- ##
## Clock (100 MHz on-board oscillator)
## ---------------------------------------------------------------- ##
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports { clk100mhz }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk100mhz }];

## ---------------------------------------------------------------- ##
## Reset push button (BTN0, active-high)
## ---------------------------------------------------------------- ##
set_property -dict { PACKAGE_PIN D9 IOSTANDARD LVCMOS33 } [get_ports { btn_rst }];

## ---------------------------------------------------------------- ##
## USB-UART bridge (FTDI FT2232HQ)
## Names are from the FTDI chip's perspective (as in Digilent's master XDC):
##   uart_rxd_out = FPGA output into the FTDI's RX  = NEORV32 uart0_txd_o
##   uart_txd_in  = FPGA input from the FTDI's TX   = NEORV32 uart0_rxd_i
## ---------------------------------------------------------------- ##
set_property -dict { PACKAGE_PIN D10 IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }];
set_property -dict { PACKAGE_PIN A9  IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }];
