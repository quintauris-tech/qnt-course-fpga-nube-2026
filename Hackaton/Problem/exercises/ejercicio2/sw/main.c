#include <neorv32.h>

// Prints a Fibonacci-like sequence over UART0.

int main(void) {

  neorv32_rte_setup(); // catch and report any trap instead of hanging silently

  neorv32_uart0_setup(19200, 0);
  neorv32_uart0_printf("\n<< Fibonacci check >>\n\n");

  uint32_t a = 1, b = 1;
  for (int i = 0; i < 10; i++) {
    uint32_t product = a * b;
    uint32_t half     = product / 2;
    neorv32_uart0_printf("i=%d  a=%u  b=%u  a*b=%u  (a*b)/2=%u\n", i, a, b, product, half);
    uint32_t next = a + b;
    a = b;
    b = next;
  }

  neorv32_uart0_printf("\nTEST DONE.\n");

  return 0;
}
