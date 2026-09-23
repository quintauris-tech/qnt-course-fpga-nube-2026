# ================================================================================ #
# NEORV32 on Digilent Arty A7-100T - Constraints (REFERENCE / SOLUTION)            #
# Target part: xc7a100tcsg324-1                                                    #
# Matches ports of neorv32_arty_top.vhd                                            #
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
## Push buttons BTN1-BTN3 (active-high), used as GPIO inputs
## btn(0)=BTN1, btn(1)=BTN2, btn(2)=BTN3
## ---------------------------------------------------------------- ##
set_property -dict { PACKAGE_PIN C9 IOSTANDARD LVCMOS33 } [get_ports { btn[0] }]; # BTN1
set_property -dict { PACKAGE_PIN B9 IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]; # BTN2
set_property -dict { PACKAGE_PIN B8 IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]; # BTN3

## ---------------------------------------------------------------- ##
## LEDs (LD4-LD7, individual, NOT the RGB LEDs)
## ---------------------------------------------------------------- ##
set_property -dict { PACKAGE_PIN H5  IOSTANDARD LVCMOS33 } [get_ports { led[0] }];
set_property -dict { PACKAGE_PIN J5  IOSTANDARD LVCMOS33 } [get_ports { led[1] }];
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports { led[2] }];
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { led[3] }];

## ---------------------------------------------------------------- ##
## USB-UART bridge (FTDI FT2232HQ)
## Names are from the FTDI chip's perspective (as in Digilent's master XDC):
##   uart_rxd_out = FPGA output into the FTDI's RX  = NEORV32 uart0_txd_o
##   uart_txd_in  = FPGA input from the FTDI's TX   = NEORV32 uart0_rxd_i
## ---------------------------------------------------------------- ##
set_property -dict { PACKAGE_PIN D10 IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }];
set_property -dict { PACKAGE_PIN A9  IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }];
