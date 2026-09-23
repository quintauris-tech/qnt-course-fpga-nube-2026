-- ================================================================================ --
-- NEORV32 on Digilent Arty A7-100T - Board Top Level                               --
-- -------------------------------------------------------------------------------- --
-- Thin wrapper directly around neorv32_top (rtl/core/neorv32_top.vhd). Only job    --
-- here: adapt board-level signals (active-high push buttons, Arty pin names) to    --
-- the core's generic port names, and expose BTN0-BTN3 as GPIO inputs.              --
--                                                                                   --
-- Programs are uploaded through the on-chip NEORV32 bootloader over UART0, using   --
-- the Arty's on-board FTDI USB-UART bridge (single USB cable, no external debug    --
-- probe needed). See sw/Makefile ("make upload").                                  --
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
    clk100mhz    : in  std_logic;                    -- E3, 100 MHz oscillator
    btn_rst      : in  std_logic;                    -- BTN0, active-high push button used as reset

    -- Push buttons BTN1..BTN3 (BTN0 is reset, see above) --
    btn          : in  std_logic_vector(2 downto 0); -- BTN1, BTN2, BTN3, active-high

    -- LEDs (LD4..LD7, individual, NOT the RGB LEDs) --
    led          : out std_logic_vector(3 downto 0);

    -- USB-UART bridge (names from the FTDI's point of view in the Digilent XDC) --
    uart_rxd_out : out std_logic;  -- FPGA -> FTDI RX  == NEORV32 uart0_txd_o
    uart_txd_in  : in  std_logic   -- FTDI TX -> FPGA  == NEORV32 uart0_rxd_i
  );
end entity;

architecture rtl of neorv32_arty_top is

  signal rstn         : std_logic;
  signal gpio_out_all : std_ulogic_vector(31 downto 0);
  signal gpio_in_all  : std_ulogic_vector(31 downto 0);

begin

  -- BTN0 is active-high on Arty A7; the processor reset is active-low --
  rstn <= not btn_rst;

  -- BTN1-BTN3 mapped to GPIO input bits 0-2, read from software via
  -- neorv32_gpio_pin_get(0..2) / neorv32_gpio_port_get(). Unused input bits
  -- are tied low.
  gpio_in_all <= (2 => std_ulogic(btn(2)),
                  1 => std_ulogic(btn(1)),
                  0 => std_ulogic(btn(0)),
                  others => '0');

  neorv32_inst: neorv32_top
  generic map (
    CLOCK_FREQUENCY  => CLOCK_FREQUENCY,
    BOOT_MODE_SELECT => 0,        -- boot via internal bootloader
    RISCV_ISA_C      => true,
    RISCV_ISA_M      => true,
    RISCV_ISA_Zicntr => true,
    IMEM_EN          => true,
    IMEM_SIZE        => IMEM_SIZE,
    DMEM_EN          => true,
    DMEM_SIZE        => DMEM_SIZE,
    IO_GPIO_NUM      => 8,        -- gpio_o/gpio_i(7:0) used; LEDs on (3:0), buttons on (2:0)
    IO_CLINT_EN      => true,
    IO_UART0_EN      => true
  )
  port map (
    clk_i       => clk100mhz,
    rstn_i      => rstn,
    gpio_o      => gpio_out_all,
    gpio_i      => gpio_in_all,
    uart0_txd_o => uart_rxd_out,
    uart0_rxd_i => uart_txd_in
  );

  -- only the 4 individual LEDs (LD4-LD7) are wired to the board --
  led <= std_logic_vector(gpio_out_all(3 downto 0));

end architecture;
