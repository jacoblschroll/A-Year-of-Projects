# Week 1 (1-Bit Microprocessor)

This project is based on the Motorola MC14500B's logic and architecture, although I've removed flags (at least for now).

The computer as a whole is made up of multiple components developed from a top-down approach such as the:
- Program Counter
- Program Memory
- Instruction Unit
- Logic Unit
- Control Unit

The instruction set is quite simple:
- 0H: No Op
- 1H: Load
- 2H: Load Compliment
- 3H: AND
- 4H: AND Compliment
- 5H: OR
- 6H: OR Compliment
- 7H: XNOR
- 8H: Store
- 9H: Store Compliment
- AH: Input Enable
- BH: Output Enable

I may add an assembler, but for now the program just has to be manually written to the ROM. There is also only a single bit of IO, to expand it you'll have to add a multiplexer and use the last 4 bits of each instruction to select IN or OUT, and the data port.