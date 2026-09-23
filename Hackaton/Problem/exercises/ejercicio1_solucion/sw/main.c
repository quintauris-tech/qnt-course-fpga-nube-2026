// ================================================================================ //
// NEORV32 on Arty A7 - Knight Rider LED sequence (hackathon REFERENCE SOLUTION)    //
// Adapted from neorv32/sw/example/demo_blink_led/main.c                           //
// ================================================================================ //

#include <neorv32.h>

#define NUM_LEDS 4

// BTN1 = speed up, BTN2 = slow down, BTN3 = reverse direction
#define BTN1_PIN 0
#define BTN2_PIN 1
#define BTN3_PIN 2

static uint32_t step_delay_ms = 120;

void delay_ms(uint32_t time_ms) {
  neorv32_aux_delay_ms(neorv32_sysinfo_get_clk(), time_ms);
}

int main(void) {

  neorv32_gpio_port_set(0);

  int pos = 0;
  int dir = 1; // +1 = shifting up, -1 = shifting down

  // remember previous button state so a held button only triggers once
  uint32_t btn_prev = 0;

  while (1) {

    // drive current LED position
    neorv32_gpio_port_set((uint32_t)(1 << pos));

    // bounce back and forth across the 4 LEDs
    if (pos == (NUM_LEDS - 1)) {
      dir = -1;
    } else if (pos == 0) {
      dir = 1;
    }
    pos += dir;

    // read buttons, react only on the rising edge (press) of each one
    uint32_t btn_now = neorv32_gpio_port_get();
    uint32_t btn_pressed = btn_now & ~btn_prev;
    btn_prev = btn_now;

    if ((btn_pressed & (1 << BTN1_PIN)) && (step_delay_ms > 20)) {
      step_delay_ms -= 20; // BTN1: speed up
    }
    if (btn_pressed & (1 << BTN2_PIN)) {
      step_delay_ms += 20; // BTN2: slow down
    }
    if (btn_pressed & (1 << BTN3_PIN)) {
      dir = -dir; // BTN3: reverse direction immediately
    }

    delay_ms(step_delay_ms);
  }

  return 0;
}
