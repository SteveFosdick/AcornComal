# AcornComal
A Disassembly of Acornsoft COMAL for the BBC Microcomputer

---------!---------!---------!---------!---------!---------!---------!---------!
This is a disassembly of Acornsoft COMAL for the BBC Microcomputer, initially
with a view to creating a "High" version to run the 6502 2nd processor.

The assembler syntax used is that of ADE / The Lancaster Assembler and the
files may be assembled by putting them on disc and transferring to a BBC
Microcomputer with one of those assemblers, using a BBC Micro Emulator
with one of those two assemblers of using a suitable cross-assembler, for
example: https://github.com/SteveFosdick/laxasm

Three versions are buildable from the same source depending on which
'head' file the assembler is invoked with:

lowhdr  - ROM low version at &8000 for ROM, like the orginal.
hirmhdr - ROM high version (&B800) for a machine with 2nd processor.
hifihdr - RAM high version (&B84B) to load on demand in 2nd processor.

If the included Makefile is used (Linux assumed) all three versions
are built.
