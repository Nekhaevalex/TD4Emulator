#  TD4 Emulator
## Description
Vanilla TD4 Emulator for macOS written with SwiftUI.

Reads/writes TD4 binaries as .td4b/.td4bin files, capable of editing binaries.

## Opcodes:
| Binary | Instruction | Argument 1 | Argument 2 | Description             |
|--------|-------------|------------|------------|-------------------------|
| 0000   | add         | A          | Im         | A=A+Im                  |
| 0001   | mov         | A          | B          | A=B + Im                |
| 0010   | in          | A          | Im         | A=In + Im               |
| 0011   | mov         | A          | Im         | A=Im                    |
| 0100   | mov         | B          | A          | B=A + Im                |
| 0101   | add         | B          | Im         | B=B + Im                |
| 0110   | in          | B          | Im         | B=In + Im               |
| 0111   | mov         | B          | Im         | B=Im                    |
| 1001   | out         | B          | Im         | Out=B + Im              |
| 1011   | out         | Im         | -          | Out=Im                  |
| 1110   | jnc         | Im         | -          | PC=Im if C!=1           |           
| 1111   | jmp         | Im         | -          | PC=Im                   |
