// ================================================================================ //
// NEORV32 on Arty A7 - Knight Rider LED sequence (HACKATHON EXERCISE)             //
//                                                                                  //
// Your task: turn this into a "Knight Rider" LED effect on LD4-LD7                //
// (one lit LED bouncing back and forth), controllable with the on-board buttons.  //
//                                                                                  //
// Board:                                                                          //
//   - LD4-LD7 are the 4 individual LEDs, wired to GPIO output bits 0-3.           //
//   - BTN1, BTN2, BTN3 are wired to GPIO input bits 0-2 (BTN0 is the board reset). //
//                                                                                  //
// Useful functions (see neorv32_gpio.h):                                          //
//   void     neorv32_gpio_port_set(uint32_t pin_mask);  // write all 32 outputs   //
//   uint32_t neorv32_gpio_port_get(void);                // read all 32 inputs    //
//   void     neorv32_aux_delay_ms(uint32_t clk_hz, uint32_t time_ms);             //
// ================================================================================ //

#include <neorv32.h>

#define NUM_LEDS 4

// GPIO input bit numbers the buttons are wired to
#define BTN1_PIN 0
#define BTN2_PIN 1
#define BTN3_PIN 2

int main(void) {

  neorv32_gpio_port_set(0); // all LEDs off

  // TODO 1: make one LED "walk" across LD4-LD7.
  //   - Keep an LED position (0..3).
  //   - Each loop iteration, turn on only that LED: neorv32_gpio_port_set(1 << pos).
  //   - Wait a bit: neorv32_aux_delay_ms(neorv32_sysinfo_get_clk(), 150);
  //   - Advance pos. For now this can just wrap around (0,1,2,3,0,1,2,...).
  while (1) {

    neorv32_gpio_port_set(0b0001); // <-- replace: make this move every iteration

    neorv32_aux_delay_ms(neorv32_sysinfo_get_clk(), 150);

    // TODO 2 (Knight Rider bounce): instead of wrapping 3 -> 0, make the LED
    // bounce back and forth: 0,1,2,3,2,1,0,1,2,3,... You'll need a direction
    // variable (+1 / -1) that flips when you hit either end.

    // TODO 3 (buttons): read the current button state with
    // neorv32_gpio_port_get() and use it to change behavior, e.g.:
    //   - BTN1 pressed -> speed up (smaller delay)
    //   - BTN2 pressed -> slow down (bigger delay)
    //   - BTN3 pressed -> reverse direction immediately
    // Tip: a button bit is set while held down. To react only once per press,
    // compare the current reading against the previous loop's reading and
    // only act on pins that just went from 0 to 1.
  }

  return 0;
}
