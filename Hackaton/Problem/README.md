# NEORV32 on Arty A7-100T — Hackathon QUINTAURIS

Self-contained repository for the hackathon: NEORV32 (RISC-V softcore) on
a Digilent Arty A7-100T. Each exercise lives in its own folder under
`exercises/`, with its VHDL wrapper, its XDC and its software already
paired up.

Includes a complete, self-contained copy of the NEORV32 core
(`rtl/core/`, `sw/common/`, `sw/lib/`, `sw/image_gen/`, `sw/bootloader/`)
— there is no need to clone the NEORV32 repo separately for anything
that follows.

The NEORV32 core is the work of its original authors
([github.com/stnolting/neorv32](https://github.com/stnolting/neorv32)),
licensed under BSD 3-Clause (see `LICENSE`); this repository adds the
board wrappers, constraints, custom bootloader and exercises specific to
this hackathon.

## Repository structure

```
neorv32-hackathon-quintauris/
├── rtl/core/                          NEORV32 core (VHDL), unmodified except:
│   └── neorv32_bootrom_image.vhd         bootloader with custom banner + no auto-boot
├── sw/
│   ├── bootloader/                    bootloader source (QUINTAURIS banner, auto-boot off)
│   └── common/, lib/, image_gen/      NEORV32 build framework (unchanged)
├── exercises/
│   ├── ejercicio1/                    EXERCISE 1 — student template
│   │   ├── src/neorv32_arty_top.vhd      top-level with TODOs (GPIO/LED/button mapping)
│   │   ├── xdc/arty_a7_100t.xdc          constraints with TODOs (LED/button pins)
│   │   ├── sw/main.c, Makefile            firmware with TODOs (LED sequence in C)
│   │   └── INSTRUCCIONES.md              how to compile and upload, to hand out
│   ├── ejercicio1_solucion/           complete solution for Exercise 1 (for the instructor)
│   ├── ejercicio2/                    EXERCISE 2 — student template
│   │   ├── src/neorv32_arty_top.vhd      top-level with a TODO (missing RISCV_ISA_* generic)
│   │   ├── xdc/arty_a7_100t.xdc          constraints already complete (not the goal here)
│   │   └── sw/main.c, neorv32_exe.bin     firmware to READ (already compiled, do not touch)
│   └── ejercicio2_solucion/           complete solution for Exercise 2 (for the instructor)
│       └── src/, xdc/, sw/               same files, with the correct generic
├── ENUNCIADOS.md                      both exercise statements, for slides
└── README.md                          this file
```

## 0. What makes this hardware different from stock NEORV32

- **Custom board wrapper**: the NEORV32 repo ships no support for the
  Arty A7-100T (no XDC, no top-level, no bitstream); these wrappers
  instantiate `neorv32_top` directly.
- **No JTAG/OCD**: programs are loaded through NEORV32's UART
  bootloader, over the Arty's single USB cable (FTDI FT2232HQ). No
  external USB-JTAG adapter required.
- **Bootloader with auto-boot disabled** (`AUTO_BOOT_EN=0` in
  `sw/bootloader/Makefile`): the stock bootloader only waits 8 seconds
  after reset before attempting an auto-boot; if the UART upload doesn't
  arrive in time, it fails. Here that timeout is disabled — the
  bootloader waits for the upload command indefinitely.
- **Custom welcome banner**: connecting over serial after a reset shows
  a Q in ASCII art + `QUINTAURIS` + build date, instead of the stock
  `NEORV32 Bootloader` text.

This is common to all exercises — each one only changes the board
wrapper, the XDC and/or the `neorv32_top` generics depending on what it
is designed to teach.

## Exercise 1 — Knight Rider (`exercises/ejercicio1/`)

**Learning goal**: understand how a VHDL top-level connects the board's
physical pins to the NEORV32 core's generic ports (`gpio_o`/`gpio_i`),
and how the XDC assigns those ports to specific physical pins. The core
itself doesn't need any special ISA extension — RV32I with
`Zicsr`/`Zifencei` is enough (the `RISCV_ISA_C` / `RISCV_ISA_M` generics
already come set to `true` in the template; enabling them isn't required
for this exercise and doesn't break anything, but choosing those
generics correctly is exactly the point of Exercise 2).

Students receive `exercises/ejercicio1/` with three incomplete pieces:

1. **`src/neorv32_arty_top.vhd`** — two TODOs: map `btn(0..2)` to the
   correct bits of `gpio_in_all`, and map `led(0..3)` to the correct
   bits of `gpio_out_all`. Everything else (clock, reset, UART, core
   generics) is already done.
2. **`xdc/arty_a7_100t.xdc`** — the `PACKAGE_PIN` for the 4 LEDs
   (LD4-LD7) and the 3 buttons (BTN1-BTN3) are missing; they need to be
   looked up in Digilent's reference manual / schematic for the Arty
   A7-100T. Clock, reset and UART are already resolved.
3. **`sw/main.c`** — the C application: move a LED, turn it into a
   bounce effect (a real Knight Rider), and react to the three buttons.
   See the full statement below.

`exercises/ejercicio1_solucion/` has the same structure, already
solved — use it to generate a verification bitstream before the
hackathon, or as a reference when grading.

### Hardware map (once correctly solved)

| Wrapper port | Board       | Function                                  |
|---------------------|-------------|-------------------------------------------|
| `clk100mhz`         | pin E3      | 100 MHz clock                              |
| `btn_rst`           | BTN0        | processor reset (active-high)              |
| `btn(0)`            | BTN1        | GPIO in, bit 0                             |
| `btn(1)`            | BTN2        | GPIO in, bit 1                             |
| `btn(2)`            | BTN3        | GPIO in, bit 2                             |
| `led(3:0)`          | LD4-LD7     | GPIO out, bits 0-3                         |
| `uart_rxd_out`/`uart_txd_in` | FTDI FT2232HQ | UART0 (bootloader + console) |

Relevant GPIO registers (base `0xFFFC0000`, see
`sw/lib/include/neorv32_gpio.h`): `PORT_OUT` (+0x04, write to move the
LEDs), `PORT_IN` (+0x00, read to see the buttons). From C, just use
`neorv32_gpio_port_set()` / `neorv32_gpio_port_get()`.

### The software statement (3 TODOs in `sw/main.c`)

1. Make the lit LED sweep across LD4→LD7 (simple sweep).
2. Turn the sweep into a bounce (a real Knight Rider:
   0,1,2,3,2,1,0,...).
3. Read `neorv32_gpio_port_get()` and react to BTN1 (speed up), BTN2
   (slow down), BTN3 (reverse direction) — detecting the rising edge so
   the action doesn't repeat on every loop iteration while the button
   stays pressed.

## Exercise 2 — Choosing the ISA extensions (`exercises/ejercicio2/`)

**Learning goal**: understand that the instruction set the CPU
implements is a *hardware* decision (`neorv32_top` generics), and that
the compiled software must match what the hardware actually supports —
if they don't match, the failure shows up at runtime, not at compile
time. This exercise doesn't touch GPIO: the firmware comes already
compiled (no C to touch), but it **does need to be read** to reason
about what it needs — the work is entirely on the VHDL top-level, based
on what the code says.

Students receive `exercises/ejercicio2/` with:

1. **`src/neorv32_arty_top.vhd`** — one TODO: the `neorv32_top` generic
   map is missing at least one `RISCV_ISA_*` generic — it isn't even
   listed, so the whole line needs to be added (generic name included),
   not just flipping a `false` to `true`. This requires reviewing
   `sw/main.c`, deciding what the program needs, and locating the exact
   generic name in `rtl/core/neorv32_top.vhd` that enables it. There are
   no LEDs or buttons in this exercise — only clock, reset and UART
   (already resolved).
2. **`xdc/arty_a7_100t.xdc`** — already complete, no modification
   needed (the goal of this exercise is the top-level, not the XDC).
3. **`sw/main.c`** — the firmware source code, to read and analyze (no
   need to compile it).
4. **`sw/neorv32_exe.bin`** — the same firmware **already compiled**; do
   not touch it, just upload it to the board once the hardware is
   fixed.

`exercises/ejercicio2_solucion/` has the same top-level, XDC and
software, already with the correct generics and with explicit comments
(for the instructor) — use it to generate a verification bitstream
before the hackathon, without handing it out to students.

### What happens if the generic is wrong

If the CPU doesn't implement the extension the program needs, it hits
the first instruction it doesn't recognize and rejects it as illegal.
The firmware installs NEORV32's default exception handler
(`neorv32_rte_setup()`), so in some cases the console (TeraTerm) shows
something like:
```
<NEORV32-RTE-PANIC> [cpu0|M] Illegal instruction @ 0x...
```
In other cases, depending on the exact CPU configuration, nothing gets
printed at all — just total silence after `Booting (@0x00000000)...`.
Both are the same signal: the hardware doesn't match what the program
needs. (Note for the instructor: `RISCV_ISA_C => false` cannot be left
in this exercise — it was verified on real hardware that it breaks the
bootloader's own boot process, not just the test program's execution;
that's why `RISCV_ISA_C` already comes fixed to `true` and isn't part of
the TODO.)

### What the correct generic looks like

With the hardware correctly configured, the console should show exactly
this (a Fibonacci-like sequence, with products and integer divisions):
```
<< Fibonacci check >>

i=0  a=1  b=1  a*b=1  (a*b)/2=0
i=1  a=1  b=2  a*b=2  (a*b)/2=1
i=2  a=2  b=3  a*b=6  (a*b)/2=3
i=3  a=3  b=5  a*b=15  (a*b)/2=7
i=4  a=5  b=8  a*b=40  (a*b)/2=20
i=5  a=8  b=13  a*b=104  (a*b)/2=52
i=6  a=13  b=21  a*b=273  (a*b)/2=136
i=7  a=21  b=34  a*b=714  (a*b)/2=357
i=8  a=34  b=55  a*b=1870  (a*b)/2=935
i=9  a=55  b=89  a*b=4895  (a*b)/2=2447

TEST DONE.
```

## 1. Setting up the hardware in Vivado (per exercise)

Everything through the Vivado GUI (2023.x/2024.x), no TCL. Repeat this
flow once per exercise (each one generates its own project and
bitstream).

### 1.1 Create the project

1. Vivado → **File → Project → New...**
2. "Project Type": **RTL Project**, check "Do not specify sources at
   this time". Next.
3. "Default Part": search for and pick `xc7a100tcsg324-1` (or the "Arty
   A7-100T" board under the Boards tab if you have the board file
   installed). Finish.

### 1.2 Add the NEORV32 core sources

1. Sources → right click → **Add Sources...** → **Add or create design
   sources** → Next.
2. **Add Directories** → select this repo's `rtl/core` folder.
3. Select all added files and set their **Library** column to
   `neorv32` (not `work`).
4. Finish, and wait for Vivado to finish analyzing dependencies.

### 1.3 Add the exercise's wrapper and XDC

1. Sources → **Add Sources...** → **Add or create design sources** →
   **Add Files** → `exercises/<exercise>/src/neorv32_arty_top.vhd`.
   Confirm it lands in the `work` library.
2. Sources → **Add Sources...** → **Add or create constraints** →
   **Add Files** → `exercises/<exercise>/xdc/arty_a7_100t.xdc`.

(replace `<exercise>` with `ejercicio1`, `ejercicio1_solucion`,
`ejercicio2` or `ejercicio2_solucion` depending on which one you're
building.)

### 1.4 Set the top-level

Under "Design Sources", `neorv32_arty_top` should show as highlighted
top. If not, right click on it → **Set as Top**.

### 1.5 Generate the bitstream and program the board

1. Flow Navigator → **PROGRAM AND DEBUG → Generate Bitstream** (accept
   running Synthesis + Implementation if asked; if the student
   exercise's XDC still has unfilled pins, this will fail with an
   "unconstrained port" error or similar — that's the signal that the
   XDC needs completing).
2. When done: **Open Hardware Manager → Open target → Auto Connect**.
3. Right click on the device → **Program Device...** → confirm the
   generated `.bit` (under
   `<project>.runs/impl_1/neorv32_arty_top.bit`) → **Program**.

The bitstream stays loaded while the board has power; there's no need
to repeat this unless it's powered off or reprogrammed with something
else.

> ⚠️ **If you touch `sw/bootloader/` again and rebuild the ROM**:
> Vivado, when adding sources with the default option, copies the files
> into the project (`<project>.srcs/sources_1/imports/core/`) instead of
> referencing them. Rebuilding `rtl/core/neorv32_bootrom_image.vhd`
> outside Vivado **does not update that copy** — it has to be
> overwritten by hand before "Generate Bitstream", or the new bitstream
> will keep the old bootloader with no error warning at all.

## 2. Compiling the exercise software (Exercise 1 only)

Exercise 2 doesn't require compiling anything — `sw/neorv32_exe.bin`
already comes ready. This section only applies to
`exercises/ejercicio1/sw/`.

`exercises/ejercicio1/INSTRUCCIONES.md` has a short (Spanish) version of
these same steps, meant to be handed directly to students.

A RISC-V GCC compiler needs to be installed. The one recommended by
NEORV32 is xPack's prebuilt package (prefix `riscv-none-elf-`), which is
the default already configured in `sw/common/common.mk` — with that
toolchain installed, compiling is as simple as:

```
cd exercises/ejercicio1/sw
make clean_all exe
```

`MARCH`/`MABI` are already correctly fixed inside each exercise's
`Makefile` (RV32I) — no need to touch them.

If your toolchain has a different prefix (for example
`riscv32-unknown-elf-` instead of `riscv-none-elf-`), point to it with
`RISCV_PREFIX`:
```
make clean_all exe RISCV_PREFIX=/path/to/your/riscv32-unknown-elf-
```

This generates `neorv32_exe.bin` in the same folder — the file that
needs to be uploaded to the bootloader (section 3). Every time
`main.c` is modified, repeat `make clean_all exe` before uploading it
again.

### 2.1 Case: repo cloned on Windows, toolchain installed in WSL

If the repository is at, for example,
`C:\git\neorv32-hackathon-quintauris` but the RISC-V compiler is only
installed inside WSL (no need to copy anything back and forth: WSL sees
`C:\` as `/mnt/c/`, so it compiles directly against the same files you
see on Windows):

```
wsl
cd /mnt/c/git/neorv32-hackathon-quintauris/exercises/ejercicio1/sw
make clean_all exe RISCV_PREFIX=/path/to/your/toolchain/riscv32-unknown-elf-
```
(adjust the repo path and `RISCV_PREFIX` to your own install — this
repo was validated this way, with a toolchain at
`/opt/riscv32/bin/riscv32-unknown-elf-` inside WSL).

The resulting `neorv32_exe.bin` ends up in the same folder, visible
from Windows at the equivalent `C:\...` path — TeraTerm (which runs on
Windows) reads it directly from there without needing to copy it
anywhere, as explained in section 3.

If `make` fails with something like `The system cannot find the file
specified` when invoking the compiler, it's almost always that
`RISCV_PREFIX` doesn't point to the right binary inside WSL, or that
`make` is being run from a Windows terminal (Git Bash/PowerShell)
instead of inside a real WSL session — check with
`which riscv32-unknown-elf-gcc` (or the matching prefix) inside WSL
before compiling.

## 3. Uploading the program to the board (TeraTerm, Windows)

No script or external bootloader needed: it's uploaded with a regular
serial terminal. Applies the same way to both exercises — for Exercise
2, the file to send already exists at
`exercises/ejercicio2/sw/neorv32_exe.bin`, nothing needs compiling
beforehand.

1. Open TeraTerm → **File → New connection → Serial** → select the
   Arty's COM port (Device Manager → Ports COM & LPT; the FTDI chip
   exposes two interfaces, try the lower-numbered one first).
2. **Setup → Serial port...**: 19200 baud, 8 bits, no parity, 1 stop
   bit, no flow control. **Important**: also set **"Transmit delay" to
   5 ms/char** — without this delay, the file upload fails with
   `ERROR_EXCEPTION` or hangs with no response because the bootloader
   doesn't consume bytes as fast as TeraTerm sends them by default.
3. Press **BTN0** on the board. You should see the QUINTAURIS banner
   and the `CMD:>` prompt — no auto-boot countdown, so there's no rush.
4. Type **`u`** (no Enter) → "Awaiting neorv32_exe.bin...".
5. **File → Send file...** → pick `neorv32_exe.bin`, **Binary** mode.
6. If it responds `OK`, type **`e`** to run the program.

If `ERROR_CHECKSUM` or `ERROR_EXCEPTION` shows up: check the "Transmit
delay" from step 2 first. If it persists, confirm the file sent is the
`.bin` (not `.elf`) and that it was sent in binary mode.

**Watch out on Exercise 2**: an `ERROR_EXCEPTION` right after typing
`e` (not during the upload) is the expected signal that the
`RISCV_ISA_M`/`RISCV_ISA_C` generics are still misconfigured — don't
confuse it with a UART upload failure. See the Exercise 2 section
above.

## 4. Known risks / things to check before the hackathon

- Identify ahead of time, on each classroom PC, which of the FTDI
  chip's two COM ports is UART0 (can vary between machines).
- Install the RISC-V toolchain on all laptops in advance — it's the
  step most likely to eat time live if it isn't ready (needed for
  Exercise 1; Exercise 2 doesn't compile anything).
- Remind students: press **BTN0** before every `u` to reset the
  bootloader (even though there's no time limit anymore, if the
  bootloader already booted a previous program it isn't listening for
  commands).
- Confirm TeraTerm's "Transmit delay" in the configuration handed out
  to students — it's the easiest failure to hit if forgotten.
- Vivado needs to be installed and licensed on every laptop that will
  build its own project (both exercises synthesize their own bitstream)
  — unlike a purely software hackathon.
