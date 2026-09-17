-- ================================================================================ --
-- NEORV32 on Digilent Arty A7-100T - Board Top Level (HACKATHON EXERCISE)          --
-- -------------------------------------------------------------------------------- --
-- Thin wrapper directly around neorv32_top (rtl/core/neorv32_top.vhd). Only job    --
-- here: adapt board-level signals (active-high push buttons, Arty pin names) to    --
-- the core's generic port names, and expose BTN1-BTN3 as GPIO inputs.              --
--                                                                                   --
-- YOUR TASK: connect the board-level LED and button ports to the right bits of     --
-- the NEORV32 core's gpio_o / gpio_i vectors. Everything else (clock, reset, UART, --
-- CPU configuration) is already wired up for you - this exercise is only about     --
-- the GPIO signal mapping.                                                         --
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

  -- ---------------------------------------------------------------- --
  -- TODO 1: map BTN1, BTN2 and BTN3 onto gpio_in_all.
  --
  -- The C firmware reads buttons with neorv32_gpio_port_get(), and
  -- expects BTN1 on bit 0, BTN2 on bit 1, BTN3 on bit 2 (see
  -- sw/main.c). btn(0)/(1)/(2) are already BTN1/BTN2/BTN3 respectively
  -- (see the port declaration above and the XDC file) - you just need
  -- to connect them to the matching bits of gpio_in_all.
  --
  -- Every other bit of gpio_in_all that you don't drive here MUST be
  -- tied to '0' (an unconnected GPIO input bit must never be left
  -- floating) - use an "others => '0'" branch in your aggregate, the
  -- same way it is done elsewhere in this file for gpio_out_all's
  -- unused bits (see below).
  -- ---------------------------------------------------------------- --
  gpio_in_all <= (others => '0'); -- <-- replace this line

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

  -- ---------------------------------------------------------------- --
  -- TODO 2: map the 4 individual LEDs (LD4-LD7) onto gpio_out_all.
  --
  -- The C firmware writes LED patterns with neorv32_gpio_port_set(),
  -- and expects LD4 on bit 0, LD5 on bit 1, LD6 on bit 2, LD7 on bit 3
  -- (see sw/main.c: it shifts a single '1' bit through positions 0..3).
  -- led(0) must end up connected to gpio_out_all's bit 0, led(1) to
  -- bit 1, and so on.
  -- ---------------------------------------------------------------- --
  led <= (others => '0'); -- <-- replace this line

end architecture;
