# ================================================================================ #
# NEORV32 on Digilent Arty A7-100T - Constraints (HACKATHON EXERCISE)              #
# Target part: xc7a100tcsg324-1                                                    #
#                                                                                   #
# YOUR TASK: this file is missing the PACKAGE_PIN assignments for the 4 LEDs and   #
# the 3 push buttons used by this exercise. Clock, reset and UART are already      #
# constrained for you - leave those as they are.                                   #
#                                                                                   #
# Look up the correct pins in the Digilent Arty A7-100T reference manual /         #
# schematic (search for "LD4", "LD5", ... and "BTN1", "BTN2", "BTN3" - NOT the     #
# RGB LEDs, and NOT BTN0, which is already used as the reset button below).        #
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
## TODO: push buttons BTN1-BTN3 (active-high), used as GPIO inputs.
## btn(0) = BTN1, btn(1) = BTN2, btn(2) = BTN3
## ---------------------------------------------------------------- ##
#set_property -dict { PACKAGE_PIN ???? IOSTANDARD LVCMOS33 } [get_ports { btn[0] }]; # BTN1
#set_property -dict { PACKAGE_PIN ???? IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]; # BTN2
#set_property -dict { PACKAGE_PIN ???? IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]; # BTN3

## ---------------------------------------------------------------- ##
## TODO: LEDs (LD4-LD7, individual, NOT the RGB LEDs).
## led[0] = LD4, led[1] = LD5, led[2] = LD6, led[3] = LD7
## ---------------------------------------------------------------- ##
#set_property -dict { PACKAGE_PIN ???? IOSTANDARD LVCMOS33 } [get_ports { led[0] }]; # LD4
#set_property -dict { PACKAGE_PIN ???? IOSTANDARD LVCMOS33 } [get_ports { led[1] }]; # LD5
#set_property -dict { PACKAGE_PIN ???? IOSTANDARD LVCMOS33 } [get_ports { led[2] }]; # LD6
#set_property -dict { PACKAGE_PIN ???? IOSTANDARD LVCMOS33 } [get_ports { led[3] }]; # LD7

## ---------------------------------------------------------------- ##
## USB-UART bridge (FTDI FT2232HQ)
## Names are from the FTDI chip's perspective (as in Digilent's master XDC):
##   uart_rxd_out = FPGA output into the FTDI's RX  = NEORV32 uart0_txd_o
##   uart_txd_in  = FPGA input from the FTDI's TX   = NEORV32 uart0_rxd_i
## ---------------------------------------------------------------- ##
set_property -dict { PACKAGE_PIN D10 IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }];
set_property -dict { PACKAGE_PIN A9  IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }];
