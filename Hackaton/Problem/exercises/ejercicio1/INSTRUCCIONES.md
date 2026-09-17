# Ejercicio 1 — Compilar y subir

## Compilar

Necesitas un compilador RISC-V GCC. Si lo tienes instalado en **WSL** y el
repositorio está clonado en Windows (por ejemplo en
`C:\git\neorv32-hackathon-quintauris`), abre una terminal (PowerShell o
Git Bash) y entra en WSL:

```powershell
wsl
```

Dentro de WSL, muévete a la carpeta del ejercicio (recuerda que WSL ve tu
disco `C:\` como `/mnt/c/`) y compila:

```bash
cd /mnt/c/git/neorv32-hackathon-quintauris/exercises/ejercicio1/sw
make clean_all exe RISCV_PREFIX=/ruta/a/tu/toolchain/riscv32-unknown-elf-
```

Ajusta `RISCV_PREFIX` a donde tengas instalado tu compilador. Si usas el
toolchain oficial de xPack (prefijo `riscv-none-elf-`), puedes omitir
`RISCV_PREFIX` por completo:

```bash
make clean_all exe
```

Si todo va bien verás algo como:

```
Memory utilization:
   text    data     bss     dec     hex filename
    656       0       0     656     290 main.elf
...
Executable (EXE): 656 bytes @ 0x00000000, checksum = 0x...
```

Esto genera `neorv32_exe.bin` en la misma carpeta — es el fichero que
tienes que subir a la placa. Repite este mismo comando cada vez que
cambies `main.c`.

## Subir a la placa

Ya sabes usar TeraTerm — solo un par de recordatorios:

- **BTN0** resetea el procesador y vuelve a lanzar el bootloader (verás
  otra vez el banner y el prompt `CMD:>`). Haz esto antes de cada `u`.
- El bootloader **no tiene límite de tiempo** para escribir `u` — no hay
  ninguna cuenta atrás que se te pueda escapar.
- Recuerda el **Transmit delay** en Setup → Serial port. Sin él, la
  subida del fichero falla aunque todo lo demás esté bien.
- Envía el `.bin` (no el `.elf`) en modo **Binary**, con `File → Send
  file...`.
- Tras el `OK`, teclea `e` para arrancar el programa.
