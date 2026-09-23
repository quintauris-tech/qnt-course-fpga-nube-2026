# Exercise statements

## Exercise 1 — Knight Rider

Program a "Knight Rider"-style light effect on the 4 LEDs (LD4-LD7) of
the Arty A7-100T, controlled with the board's push buttons.

**Challenge:**
1. Make a lit LED sweep across LD4 → LD7.
2. Turn that sweep into a bounce (a real Knight Rider):
   0,1,2,3,2,1,0,1,2,3...
3. Use the buttons to control it in real time: one speeds it up, one
   slows it down, one reverses the direction.

**Files to modify:** `exercises/ejercicio1/sw/main.c` (C only — the
hardware is already solved).

**Success criterion:** the light pattern moves as requested and
responds to the three buttons.

---

## Exercise 2 — Choosing the right processor

You're given an already-compiled program (`sw/neorv32_exe.bin`) and
its source code (`sw/main.c`). Running it on the board, it doesn't
work correctly.

**Challenge:**
1. Read `sw/main.c` and figure out what the program needs from the
   processor to run correctly.
2. Open `src/neorv32_arty_top.vhd` and locate where the processor is
   configured (the `generic map` block of `neorv32_top`).
3. Add the missing generic so the hardware is able to run the program.
   You'll need to look up its exact name in `rtl/core/neorv32_top.vhd`.
4. Generate a new bitstream, program it, and upload the same `.bin`
   (no need to compile anything) to check the result.

**Files to modify:** `exercises/ejercicio2/src/neorv32_arty_top.vhd`
(VHDL only — the software is already compiled, don't touch it).

**Success criterion:** running the program, the console shows a
correctly computed sequence of numbers instead of staying silent or
showing an illegal-instruction error.
