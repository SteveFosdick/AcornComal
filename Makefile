all: comal.dis test.rom

CCDIS = ccdis -L -b 0x8000 -l labels -s comal.rom

comal.dis: comal.rom labels
	$(CCDIS) > comal.dis

#comal.asm: comal.rom labels
#	$(CCDIS) -a > comal.asm

test.rom: comal.asm
	laxasm -l comal.lst -o test.rom comal.asm
	cmp test.rom comal.rom
