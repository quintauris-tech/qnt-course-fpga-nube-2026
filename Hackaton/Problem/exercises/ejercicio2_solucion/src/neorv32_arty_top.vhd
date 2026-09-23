-- ================================================================================ --
-- NEORV32 on Digilent Arty A7-100T - Board Top Level (Exercise 2 REFERENCE)        --
-- -------------------------------------------------------------------------------- --
-- Thin wrapper directly around neorv32_top (rtl/core/neorv32_top.vhd). No LEDs or  --
-- buttons - CPU configured with the extensions sw/main.c (sw/neorv32_exe.bin)      --
-- needs: RISCV_ISA_M (the program uses integer multiply/divide). RISCV_ISA_C is    --
-- kept enabled regardless of what the program needs - RISCV_ISA_C=false has been   --
-- observed to prevent the bootloader itself from booting on this core/toolchain    --
-- combination (see notes in the student-facing wrapper), so it isn't exposed as    --
-- part of the exercise.                                                            --
--                                                                                  --
-- Programs are uploaded through the on-chip NEORV32 bootloader over UART0, using   --
-- the Arty's on-board FTDI USB-UART bridge (single USB cable, no external debug    --
-- probe needed).                                                                   --
-- ================================================================================ --

library ieee;
use ieee.std_logic_1164.all;

library neorv32;
use neorv32.neorv32_package.all;

entity neorv32_arty_top is
  generic (
    CLOCK_FREQUENCY : natural := 100000000; -- Arty A7 100 MHz oscillator (pin E3)
    IMEM_SIZE        : natural := 16*1024;
    DMEM_SIZE        : natural := 8*1024
  );
  port (
    -- Board clock / reset --
    clk100mhz    : in  std_logic;  -- E3, 100 MHz oscillator
    btn_rst      : in  std_logic;  -- BTN0, active-high push button used as reset

    -- USB-UART bridge (names from the FTDI's point of view in the Digilent XDC) --
    uart_rxd_out : out std_logic;  -- FPGA -> FTDI RX  == NEORV32 uart0_txd_o
    uart_txd_in  : in  std_logic   -- FTDI TX -> FPGA  == NEORV32 uart0_rxd_i
  );
end entity;

architecture rtl of neorv32_arty_top is

  signal rstn : std_logic;

begin

  -- BTN0 is active-high on Arty A7; the processor reset is active-low --
  rstn <= not btn_rst;

  neorv32_inst: neorv32_top
  generic map (
    CLOCK_FREQUENCY  => CLOCK_FREQUENCY,
    BOOT_MODE_SELECT => 0,        -- boot via internal bootloader
    RISCV_ISA_C      => true,
    RISCV_ISA_M      => true,     -- sw/main.c was compiled with -march=rv32im
    RISCV_ISA_Zicntr => true,
    IMEM_EN          => true,
    IMEM_SIZE        => IMEM_SIZE,
    DMEM_EN          => true,
    DMEM_SIZE        => DMEM_SIZE,
    IO_GPIO_NUM      => 8,         -- kept enabled (unused, no board pins here) -
                                   -- IO_GPIO_NUM=0 has been observed to prevent
                                   -- the bootloader from booting on this core/
                                   -- toolchain combination; not part of this
                                   -- exercise's TODO, leave as-is
    IO_CLINT_EN      => true,
    IO_UART0_EN      => true
  )
  port map (
    clk_i       => clk100mhz,
    rstn_i      => rstn,
    uart0_txd_o => uart_rxd_out,
    uart0_rxd_i => uart_txd_in
  );

end architecture;
