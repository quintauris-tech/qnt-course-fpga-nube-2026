# Exercise 1 — Compile and upload

## Compiling

You need a RISC-V GCC compiler. If you have it installed in **WSL** and
the repository is cloned on Windows (for example at
`C:\git\neorv32-hackathon-quintauris`), open a terminal (PowerShell or
Git Bash) and enter WSL:

```powershell
wsl
```

Inside WSL, move to the exercise folder (remember WSL sees your `C:\`
drive as `/mnt/c/`) and compile:

```bash
cd /mnt/c/git/neorv32-hackathon-quintauris/exercises/ejercicio1/sw
make clean_all exe RISCV_PREFIX=/path/to/your/toolchain/riscv32-unknown-elf-
```

Adjust `RISCV_PREFIX` to wherever your compiler is installed. If you're
using xPack's official toolchain (prefix `riscv-none-elf-`), you can
skip `RISCV_PREFIX` entirely:

```bash
make clean_all exe
```

If everything goes well you'll see something like:

```
Memory utilization:
   text    data     bss     dec     hex filename
    656       0       0     656     290 main.elf
...
Executable (EXE): 656 bytes @ 0x00000000, checksum = 0x...
```

This generates `neorv32_exe.bin` in the same folder — this is the file
you need to upload to the board. Repeat this same command every time
you change `main.c`.

## Uploading to the board

You already know how to use TeraTerm — just a couple of reminders:

- **BTN0** resets the processor and relaunches the bootloader (you'll
  see the banner and the `CMD:>` prompt again). Do this before every
  `u`.
- The bootloader has **no time limit** for typing `u` — there's no
  countdown you could miss.
- Remember the **Transmit delay** in Setup → Serial port. Without it,
  the file upload fails even if everything else is right.
- Send the `.bin` (not the `.elf`) in **Binary** mode, with
  `File → Send file...`.
- After the `OK`, type `e` to run the program.
