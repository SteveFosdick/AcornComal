all: comal.dis hicomal.ssd

hicomal.ssd: lowrom hirom hifile
	cp blank.ssd hicomal.ssd
	afscp lowrom hicomal.ssd:lowrom
	afscp hirom hicomal.ssd:hirom
	afscp hifile hicomal.ssd:hifile

CCDIS = ccdis -L -b 0x8000 -l labels -s comal.rom

comal.dis: comal.rom labels
	$(CCDIS) > comal.dis

#comal.asm: comal.rom labels
#	$(CCDIS) -a > comal.asm

lowrom: lowhdr service source
	laxasm -l lowlst -o lowrom lowhdr
	cmp lowrom comal.rom

hirom: hirmhdr service source
	laxasm -l hirmlst -o hirom hirmhdr

hifile: hifihdr source
	laxasm -l hifilst -o hifile hifihdr
