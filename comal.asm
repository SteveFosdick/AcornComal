                       ORG     $8000
himem                  EQU     $0000
lomem                  EQU     $0002
aestkp                 EQU     $0004
page                   EQU     $0006
vartop                 EQU     $0008
prgtop                 EQU     $000C
locall                 EQU     $000E
localh                 EQU     $0010
closed                 EQU     $0012
txtptr                 EQU     $0013
txtoff                 EQU     $0015
erflag                 EQU     $003F
pdbugd                 EQU     $0068
lstkp                  EQU     $006F
osnewl                 EQU     $FFE7
oswrch                 EQU     $FFEE
osword                 EQU     $FFF1
osbyte                 EQU     $FFF4
L8000:                 JMP     lang
                       JMP     serv
L8006:                 DFB     $C2, $0E, $10                          ; ...
D8009:                 DFB     $43, $4F, $4D, $41, $4C, $00, $28, $43 ; COMAL.(C
                       DFB     $29, $41, $63, $6F, $72, $6E, $00      ; )Acorn.
serv:                  PHA
                       CMP     #$04
                       BNE     notcmd
                       TYA
                       PHA
                       LDX     #$FF
L8021:                 LDA     ($F2),Y
                       AND     #$DF
                       INX
                       INY
                       CMP     D8009,X
                       BEQ     L8021
                       CPX     #$05
                       BCS     L803E
                       CPX     #$01
                       BEQ     L8038
                       CMP     #$0E
                       BEQ     L803E
L8038:                 LDX     $F4
                       PLA
                       TAY
svdone:                PLA
                       RTS
L803E:                 CMP     #$20
                       BCS     L8038
                       LDX     $F4
                       LDA     #$8E
                       JMP     osbyte
notcmd:                CMP     #$09
                       BNE     svdone
                       TYA
                       PHA
                       JSR     osnewl
                       LDX     #$00
L8054:                 LDA     D8009,X
                       BEQ     L805F
                       JSR     oswrch
                       INX
                       BNE     L8054
L805F:                 JSR     osnewl
                       JMP     L8038
S8065:                 JSR     S902F
L8068:                 LDX     #$00
                       STX     pdbugd
                       STA     erflag
                       LDX     $28
                       BEQ     L8098
                       STX     $3E
                       JSR     S8AA0
                       JSR     S810E
                       JSR     L8A0F
                       BMI     L8084
                       JSR     S81C1
                       BCS     L808B
L8084:                 LDA     #$1A
                       STA     erflag
                       JSR     S810E
L808B:                 LDX     #$19
                       LDA     #$5F
                       JSR     L834C
                       JSR     S835B
                       JMP     chkesc
L8098:                 SEC
                       RTS
S809A:                 LDA     $3E
                       BMI     L80A9
                       LDY     #$01
                       LDA     $42
                       STA     (txtptr),Y
                       INY
                       LDA     $41
                       STA     (txtptr),Y
L80A9:                 JSR     S810E
S80AC:                 JSR     S81AF
                       LDX     $25
                       LDA     #$20
                       JSR     S834F
                       LDA     #$5E
                       JSR     outchr
                       JMP     S835B
brkhnd:                STA     erflag
                       LDX     $2D
                       BEQ     L80C8
                       TXS
                       JSR     S8AF6
L80C8:                 LDY     #$00
                       LDA     ($FD),Y
                       BEQ     L80E4
                       STA     erflag
                       BPL     L80E4
                       JSR     S835B
L80D5:                 INY
                       LDA     ($FD),Y
                       BEQ     L80DF
                       JSR     outchr
                       BCS     L80D5
L80DF:                 JSR     S835B
                       BCS     L80ED
L80E4:                 JSR     S810E
                       LDA     erflag
                       CMP     #$16
                       BCC     L80F0
L80ED:                 JSR     S80AC
L80F0:                 BIT     $3E
                       BPL     L80FA
                       LDX     #$00
                       STX     $82
                       BEQ     L810B
L80FA:                 LDA     erflag
                       CMP     #$13
                       BNE     L8103
                       JSR     S8A01
L8103:                 LDX     txtptr
                       STX     $80
                       LDX     txtptr+1
                       STX     $81
L810B:                 JMP     L838F
S810E:                 JSR     S835B
                       LDA     #$3A
                       STA     $2B
                       LDA     #$82
                       STA     $2C
                       LDY     #$11
                       STY     $43
                       LDY     #$00
L811F:                 LDA     $43
                       CMP     erflag
                       BEQ     L8132
L8125:                 LDA     ($2B),Y
                       PHP
                       JSR     S89C4
                       PLP
                       BNE     L8125
                       INC     $43
                       BNE     L811F
L8132:                 LDA     ($2B),Y
                       BEQ     L813B
                       JSR     S815D
                       BNE     L8132
L813B:                 LDA     erflag
                       CMP     #$1D
                       BNE     L8146
                       LDA     $69
                       JSR     S815D
L8146:                 LDA     $3E
                       BMI     L815A
                       LDY     #$08
L814C:                 LDA     L8231,Y
                       JSR     outchr
                       DEY
                       BPL     L814C
                       LDX     #$00
                       JSR     S81F8
L815A:                 JMP     S835B
S815D:                 STA     $67
                       CMP     #$01
                       BEQ     L81A3
                       TAX
                       BPL     L81A0
                       LDA     #$7C
                       STA     $29
                       LDA     #$87
                       STA     $2A
                       LDA     #$FD
                       STA     $6D
                       LDX     #$00
L8174:                 LDA     $67
                       CMP     $6D
                       BNE     L8186
L817A:                 LDA     ($29,X)
                       BMI     L8195
                       JSR     outchr
                       JSR     S89BD
                       BNE     L817A
L8186:                 LDA     ($29,X)
                       PHP
                       JSR     S89BD
                       PLP
                       BPL     L8186
                       DEC     $6D
                       BMI     L8174
                       BPL     L81A3
L8195:                 AND     #$7F
                       CMP     #$3A
                       BEQ     L81A0
                       JSR     outchr
                       LDA     #$20
L81A0:                 JSR     outchr
L81A3:                 CPY     txtoff
                       BEQ     L81A9
                       BCS     L81AD
L81A9:                 LDA     $0B
                       STA     $25
L81AD:                 INY
                       RTS
S81AF:                 JSR     S832B
                       SEC
                       ROR     $76
                       LDY     #$04
                       BIT     $3E
                       BPL     S81C1
                       LDA     txtptr+1
                       CMP     page+1
                       BCC     L81D2
S81C1:                 JSR     S81F6
                       LDY     #$04
                       BIT     $76
                       BMI     L81D2
                       LDA     (txtptr),Y
                       ASL     
                       ORA     #$01
                       JSR     S8347
L81D2:                 INY
L81D3:                 LDA     (txtptr),Y
                       CMP     #$0D
                       BEQ     L815A
                       BIT     $76
                       BPL     L81E8
                       CMP     #$FE
                       BNE     L81E8
                       LDA     #$CB
                       JSR     S815D
                       LDA     (txtptr),Y
L81E8:                 JSR     S815D
                       LDA     $67
                       JSR     S8AB2
                       BNE     L81D3
                       INY
                       INY
                       BNE     L81D3
S81F6:                 LDX     #$05
S81F8:                 LDY     #$02
                       LDA     (txtptr),Y
                       STA     $41
                       DEY
                       LDA     (txtptr),Y
                       STA     $42
                       TXA
                       DFB     $2C          ; BIT - skips the next instruction.
S8205:                 LDA     #$05
                       PHA
                       LDA     #$00
                       STA     $43
                       STA     $44
                       JSR     SB2F1
                       LDA     #$00
                       STA     $50
                       JSR     S97ED
                       PLA
                       BEQ     L8221
                       SEC
                       SBC     $4F
                       JSR     S8347
L8221:                 LDX     #$00
                       BEQ     L822C
L8225:                 LDA     $0600,X
                       JSR     outchr
                       INX
L822C:                 CPX     $4F
                       BCC     L8225
                       RTS
L8231:                 ASC     " enil ta Escape|@Can't ^y|@^I|@No room|@Bad program|@Syntax error|@Bad type|@Uncl"
                       ASC     "osed at|@Name mismatch|@^e|@Not allowed|@Too complex|@No |@Bad ^L|@String too lon"
                       ASC     "g|@Not found|@Bad value|@"
                       DFB     $9B,$00
                       ASC     "Record overflow|@Not open|@Bad ^V|@Variable exists|@File open|@No ^g|@Parm block "
                       ASC     "error|@^5|@|@"
S832B:                 LDA     #$20
outchr:                CMP     #$0D
                       BEQ     S835B
                       PHA
                       LDA     $0A
                       BEQ     L833F
                       LDA     $0B
                       CMP     $0A
                       BCC     L833F
                       JSR     S835B
L833F:                 INC     $0B
                       PLA
                       JSR     oswrch
                       SEC
                       RTS
S8347:                 TAX
                       BEQ     L8352
                       LDA     #$20
L834C:                 JSR     outchr
S834F:                 DEX
                       BNE     L834C
L8352:                 RTS
CLS:                   LDA     #$0C
                       JSR     oswrch
                       CLC
                       BCC     L835F
S835B:                 JSR     osnewl
                       SEC
L835F:                 LDA     #$00
                       STA     $0B
L8363:                 RTS
lang:                  CMP     #$01
                       BNE     L8363
                       LDX     #$FF
                       TXS
                       LDA     #$BE
                       LDY     #$80
                       STA     $0202
                       STY     $0203
                       LDY     #$09
                       STY     $0401
                       INY
                       STY     $0400
                       INX
                       STX     $0A
                       STX     $0402
                       STX     $0403
                       JSR     SAA41
                       BCC     L838F
L838C:                 JSR     S809A
L838F:                 CLI
                       LDX     #$FF
                       TXS
                       INX
                       STX     $2D
                       LDA     #$7E
                       JSR     osbyte
                       LDA     #$5D
                       JSR     outchr
                       JSR     rdline
                       LDA     #$80
                       STA     $3E
                       JSR     S8A27
                       BEQ     L83B1
                       JSR     S89CD
                       LSR     $3E
L83B1:                 JSR     toklin
                       BCS     L838C
                       LDA     $3E
                       BPL     L83C0
                       JSR     execim
                       JMP     L838F
L83C0:                 JSR     S843B
                       JMP     L838F
rdline:                SEC
                       ROR     $3E
                       LDA     #$01
                       LDY     #$07
                       STA     txtptr
                       STY     txtptr+1
                       LDX     #$00
                       STX     txtoff
S83D5:                 STA     $06A0
                       STY     $06A1
                       LDX     #$7F
                       STX     $06A2
                       DEX
                       STX     $06A4
                       LDA     #$20
                       STA     $06A3
                       LDX     #$A0
                       LDY     #$06
                       LDA     #$00
                       STA     $0B
                       JSR     osword
                       STY     $6C
                       BCC     L8406
escape:                LDA     #$7E
                       JSR     osbyte
                       BRK
L83FE:                 DFB     $11
S83FF:                 JSR     $FFE0
chkesc:                BIT     $FF
                       BMI     escape
L8406:                 RTS
toklin:                JSR     S8B28
                       JSR     S8AE5
                       JSR     S93B5
                       BCC     L8434
                       JSR     S89CD
                       JSR     SBEF1
                       JSR     S8AF6
                       LDA     $19
                       SEC
                       SBC     txtptr
                       CLC
                       ADC     #$05
                       SEC
L8424:                 PHP
                       STA     txtoff
                       LDA     txtptr
                       SEC
                       SBC     #$05
                       STA     txtptr
                       BCS     L8432
                       DEC     txtptr+1
L8432:                 PLP
                       RTS
L8434:                 JSR     S8AF6
                       LDA     #$05
                       BNE     L8424
S843B:                 JSR     S8582
                       LDA     $6C
                       BEQ     L8447
                       CLC
                       ADC     #$05
                       STA     $6C
L8447:                 JSR     S89E0
                       PHP
                       LDY     #$03
                       PLP
                       BEQ     L8479
                       LDA     $6C
                       BEQ     L8476
L8454:                 JSR     S84A7
L8457:                 LDY     #$00
                       LDA     #$0D
                       STA     ($26),Y
                       INY
                       LDA     $42
                       STA     ($26),Y
                       INY
                       LDA     $41
                       STA     ($26),Y
                       INY
                       LDA     $6C
                       STA     ($26),Y
                       INY
L846D:                 INY
                       LDA     (txtptr),Y
                       STA     ($26),Y
                       CPY     $6C
                       BNE     L846D
L8476:                 JMP     L8681
L8479:                 LDA     $6C
                       SBC     ($26),Y
                       BEQ     L8457
                       BCS     L8454
                       EOR     #$FF
                       ADC     #$01
                       TAY
                       LDX     #$00
                       LDA     $26
                       STA     $2B
                       LDA     $27
                       STA     $2C
L8490:                 LDA     ($2B),Y
                       STA     ($2B,X)
                       JSR     S89C4
                       LDA     prgtop
                       CMP     $2B
                       LDA     prgtop+1
                       SBC     $2C
                       BCS     L8490
                       LDA     $6C
                       BEQ     L8476
                       BNE     L8457
S84A7:                 TAY
                       CLC
                       ADC     prgtop
                       STA     $0C
                       BCC     L84B1
                       INC     prgtop+1
L84B1:                 LDA     prgtop
                       CMP     himem
                       LDA     prgtop+1
                       SBC     himem+1
                       BCS     L84D4
                       LDX     #$00
L84BD:                 LDA     (prgtop,X)
                       STA     (prgtop),Y
                       LDA     prgtop
                       BNE     L84C7
                       DEC     prgtop+1
L84C7:                 DEC     prgtop
                       LDA     prgtop
                       CMP     $26
                       LDA     prgtop+1
                       SBC     $27
                       BCS     L84BD
                       RTS
L84D4:                 ROR     $3E
                       BRK
L84D7:                 DFB     $14                                    ; .
S84D8:                 LDA     #$00
                       STA     $3B
                       STA     $1D
                       LDA     #$0A
                       STA     $3A
                       STA     $1C
                       BNE     L84F1
S84E6:                 LDX     #$00
                       STX     $3A
                       STX     $3B
                       DEX
                       STX     $1C
                       STX     $1D
L84F1:                 JSR     S89B1
                       BEQ     L8507
                       JSR     S8A27
                       BEQ     L8502
                       LDX     #$3A
                       JSR     LA52A
                       LDA     $6A
L8502:                 CMP     #$2C
                       BEQ     L850F
                       RTS
L8507:                 LDA     #$7F
                       AND     $1D
                       STA     $1D
                       BPL     L851C
L850F:                 JSR     SB304
                       JSR     S8A27
                       BEQ     L8507
                       LDX     #$1C
                       JSR     LA52A
L851C:                 LDX     #$3A
                       JSR     SA43A
NULL:                  CLC
L8522:                 RTS
execim:                LDA     $6C
                       BEQ     L8522
                       JSR     S8B11
                       TXA
S852B:                 STA     $69
                       TAY
                       BMI     L8539
                       DEC     txtoff
                       CMP     #$2A
                       BEQ     L8551
                       JMP     LAE1E
L8539:                 ASL     
                       TAY
                       LDA     cmdtab-$7D,Y
                       PHA
                       LDA     cmdtab-$7E,Y
                       PHA
                       LDA     $69
                       JMP     LB308
COSCLI:                JSR     S86F2
                       LDX     #$00
                       LDY     #$06
                       BNE     L855C
L8551:                 LDY     txtptr+1
                       LDA     txtptr
                       CLC
                       ADC     txtoff
                       BCC     L855B
                       INY
L855B:                 TAX
L855C:                 JSR     $FFF7
                       CLC
                       RTS
CONT:                  LDA     $80
                       STA     txtptr
                       LDA     $81
                       STA     txtptr+1
                       LDA     $82
                       STA     txtoff
                       BEQ     L857E
                       LSR     $3E
                       CMP     #$07
                       BCC     L857B
                       JSR     SBCB1
                       JMP     L8777
L857B:                 JMP     L875C
L857E:                 BRK
L857F:                 DFB     $12                                    ; .
STOP:                  BRK
L8581:                 DFB     $13                                    ; .
S8582:                 JSR     S8F43
                       TXA
                       JSR     SA505
L8589:                 LDY     #$00
                       LDA     ($26),Y
                       CMP     #$0D
                       BNE     L85A1
                       INY
                       LDA     ($26),Y
                       BMI     L85AB
                       LDY     #$03
                       LDA     ($26),Y
                       BEQ     L85A1
                       JSR     S8A14
                       BCC     L8589
L85A1:                 JSR     L85AB
                       STX     pdbugd
                       DEX
                       STX     $3E
                       BRK
L85AA:                 DFB     $15                                    ; .
L85AB:                 CLC
                       LDA     $26
                       ADC     #$02
                       STA     prgtop
                       TXA
                       ADC     $27
                       STA     prgtop+1
                       CLC
                       RTS
OLD:                   JSR     NEW
                       LDA     #$00
                       LDY     #$01
                       STA     (page),Y
                       JMP     L8681
EDIT:                  SEC
                       DFB     $24          ; BIT - skip the next instruction
LIST:                  CLC
                       ROR     $76
                       JSR     S84E6
                       BIT     $1D
                       BPL     L85D9
                       LDA     $3A
                       STA     $1C
                       LDA     $3B
                       STA     $1D
L85D9:                 LDA     #$00
                       JSR     S8D47
                       JSR     S89E0
                       PHP
                       JSR     S8AA0
                       PLP
                       BNE     L85F1
L85E8:                 JSR     chkesc
                       JSR     S81C1
                       JSR     S8A01
L85F1:                 BMI     L8600
                       LDY     #$02
                       LDA     $1C
                       CMP     (txtptr),Y
                       DEY
                       LDA     $1D
                       SBC     (txtptr),Y
                       BCS     L85E8
L8600:                 RTS
RENUM:                 JSR     S84D8
                       LDX     #$40
                       STX     $3E
                       JSR     S8F46
L860B:                 LDY     #$01
                       LDA     (txtptr),Y
                       BPL     L8612
                       RTS
L8612:                 LDA     $3B
                       STA     (txtptr),Y
                       INY
                       LDA     $3A
                       STA     (txtptr),Y
                       JSR     S862C
                       BMI     L8625
                       JSR     S8A01
                       BCC     L860B
L8625:                 LDA     #$21
                       STA     $28
                       JMP     L8068
S862C:                 CLC
                       LDA     $3A
                       ADC     $1C
                       STA     $3A
                       LDA     $3B
                       ADC     $1D
                       STA     $3B
L8639:                 RTS
DEL:                   JSR     S8582
                       JSR     S8A27
                       JSR     S89E0
                       BCC     L8639
                       LDA     $26
                       STA     $29
                       LDA     $27
                       STA     $2A
                       LDA     $6A
                       CMP     #$2C
                       BNE     L865D
                       INC     txtoff
                       JSR     S8A27
                       JSR     S89E0
                       BNE     L8660
L865D:                 JSR     S8A14
L8660:                 LDA     $29
                       CMP     $26
                       LDA     $2A
                       SBC     $27
                       BCS     L8681
L866A:                 LDA     ($26,X)
                       STA     ($29,X)
                       JSR     S89BD
                       INC     $26
                       BNE     L8677
                       INC     $27
L8677:                 LDA     prgtop
                       CMP     $26
                       LDA     prgtop+1
                       SBC     $27
                       BCS     L866A
L8681:                 LDA     #$00
                       STA     $82
                       STA     pdbugd
                       JSR     S8582
                       JMP     LAA63
LOAD:                  JSR     S86CD
                       LDA     page+1
                       STA     $0683
                       LDA     #$00
                       STA     $0686
                       LDA     #$FF
L869C:                 JSR     $FFDD
                       JMP     L8681
SAVE:                  JSR     S86CD
                       JSR     S8582
                       LDA     page+1
                       STA     $068B
                       LDY     prgtop+1
                       LDX     prgtop
                       INX
                       STX     $068E
                       BNE     L86B8
                       INY
L86B8:                 STY     $068F
                       LDX     #$80
                       LDY     #$06
                       LDA     #$00
                       JSR     $FFDD
                       CLC
                       RTS
DELETE:                JSR     S86CD
                       LDA     #$06
                       BNE     L869C
S86CD:                 LDX     #$11
                       LDA     #$00
                       STA     $4F
L86D3:                 STA     $0680,X
                       DEX
                       BPL     L86D3
                       LDA     page+1
                       STA     $0683
                       LDA     #$8F
                       STA     $0686
                       LDA     #$83
                       STA     $0687
                       LDA     #$00
                       STA     $0680
                       LDA     #$06
                       STA     $0681
S86F2:                 JSR     expr1
S86F5:                 LDY     $4F
                       INC     $4F
                       LDA     #$0D
                       STA     $0600,Y
                       LDX     #$80
                       LDY     #$06
L8702:                 RTS
AUTO:                  JSR     S84D8
                       JSR     S835B
L8709:                 LDX     #$3A
                       JSR     SA43A
                       JSR     S8205
                       LDX     #$3A
                       JSR     SA43A
                       JSR     S832B
                       JSR     rdline
                       LDX     #$40
                       STX     $3E
                       JSR     toklin
                       BCC     L872A
                       JSR     S809A
                       BCS     L8709
L872A:                 JSR     S843B
                       JSR     S862C
                       BPL     L8709
                       STA     $3E
                       LDA     #$21
                       STA     erflag
                       JMP     S810E
RUN:                   CPX     #$0D
                       BEQ     L8742
                       JSR     LOAD
L8742:                 LDX     #$00
                       STX     $3E
                       STX     closed
                       STX     lstkp
                       LDX     #$FD
                       TXS
                       LDA     #$FF
                       JSR     S8D47
                       LDA     pdbugd
                       BEQ     L8702
                       JSR     LAA63
                       JSR     S8F46
L875C:                 LDY     #$06
                       STY     txtoff
                       STY     $82
                       JSR     chkesc
                       LDY     #$01
                       LDA     (txtptr),Y
                       BPL     L876E
                       JMP     LBF1D
L876E:                 LDY     #$05
                       LDA     (txtptr),Y
                       JSR     S852B
                       BCS     L875C
L8777:                 JSR     S8A01
                       BCC     L875C
L877C:                 ASC     "CLOSE^DREAD ONL^YOL^DDEBU^GCON^TLIS^TEDI^TRENUMBE^RAUT^OPRIN^TFO^RWHIL^EI^FREPEA^T"
                       ASC     "CAS^EPRO^CFUN^CELI^FWHE^NELS^EOTHERWIS^EIMPOR^TRETUR^NNEX^TEN^DUNTI^LCOLOU^RENVEL"
                       ASC     "OP^ESOUN^DPLO^TMOV^EGCO^LDRA^WCLOS^EREA^DWRIT^EINPU^TOPE^NOSCL^IDI^MVD^USELECT OU"
                       ASC     "TPU^TDELET^ELOA^DSAV^ERU^NDAT^A/^/DE^LGOT^OEXE^CRESTOR^ESTO^PNE^WCL^SCL^GNUL^LCLE"
                       ASC     "A^RZON^EWIDT^HTIM^EPAG^EMOD^EPOINT^(RND^(STR^$INKEY^$CHR^$US^RNO^TINKE^YEX^TEO^FA"
                       ASC     "DVA^LAB^SSG^NIN^TTA^NSQ^RSI^NRA^DLO^GL^NEX^PDE^GCO^SAT^NAS^NAC^SVA^LOR^DLE^NGET^$"
                       ASC     "VPO^SFRE^ESIZ^EPO^SGE^TEO^DCOUN^TTRU^EP^IFALS^E^:USIN^GT^OTHE^NTAB^(STE^PRE^FRAND"
                       ASC     "O^MO^FFIL^ED^OAPPEN^DI^NO^RMO^DEO^RDI^VAN^D|@"
S8967:                 JSR     LB308
S896A:                 TXA
islc:                  CMP     #$7B
                       BCS     L8992
                       CMP     #$61
                       BCS     L8990
                       CMP     #$5B
                       BCS     L8992
                       CMP     #$41
                       BCS     L8990
                       BCC     L8992
S897D:                 JSR     islc
                       BCC     L8990
                       CMP     #$5F
                       BEQ     L8990
isdig:                 CMP     #$3A
                       BCS     L8992
                       CMP     #$30
                       BCS     L8990
                       BCC     L8992
L8990:                 CLC
                       DFB      $24         ; BIT - skips next instruction.
L8992:                 SEC
                       RTS
isxdig:                JSR     isdig
                       BCC     L8990
                       CMP     #$61
                       BCC     isxuc
                       CMP     #$67
                       BCS     L8992
                       AND     #$DF
                       CLC
                       RTS
isxuc:                 CMP     #$41
                       BCC     L8992
                       CMP     #$47
                       BCS     L8992
                       CLC
                       RTS
S89AF:                 INC     txtoff
S89B1:                 JSR     LB308
S89B4:                 LDA     $6A
S89B6:                 CMP     #$0D
                       BEQ     L89BC
                       CMP     #$CE
L89BC:                 RTS
S89BD:                 INC     $29
                       BNE     L89C3
                       INC     $2A
L89C3:                 RTS
S89C4:                 INC     $2B
                       BNE     L89CA
                       INC     $2C
L89CA:                 LDA     ($2B),Y
                       RTS
S89CD:                 LDA     txtoff
                       CLC
                       ADC     txtptr
                       STA     txtptr
                       LDA     #$00
                       TAY
                       ADC     txtptr+1
                       STA     txtptr+1
                       LDA     (txtptr),Y
                       STY     txtoff
                       RTS
S89E0:                 JSR     S8F43
                       BEQ     L89E8
L89E5:                 JSR     S8A14
L89E8:                 LDY     #$01
                       LDA     ($26),Y
                       CLC
                       BMI     L8A00
                       CMP     $42
                       BCC     L89E5
                       BNE     L89FE
                       INY
                       LDA     ($26),Y
                       CMP     $41
                       BCC     L89E5
                       BEQ     L8A00
L89FE:                 LDA     #$01
L8A00:                 RTS
S8A01:                 LDY     #$03
                       LDA     (txtptr),Y
                       CLC
                       ADC     txtptr
                       STA     txtptr
                       BCC     L8A0F
                       INC     txtptr+1
                       CLC
L8A0F:                 LDY     #$01
                       LDA     (txtptr),Y
                       RTS
S8A14:                 LDY     #$03
                       LDA     ($26),Y
                       CLC
                       ADC     $26
                       STA     $26
                       BCC     L8A22
                       INC     $27
                       CLC
L8A22:                 LDY     #$01
                       LDA     ($26),Y
                       RTS
S8A27:                 JSR     LB308
                       TXA
                       JSR     isdig
                       LDX     #$00
                       BCS     L8A6F
                       STX     $41
                       STX     $42
L8A36:                 LDA     $41
                       LDX     $42
                       ASL     $41
                       ROL     $42
                       ASL     $41
                       ROL     $42
                       ADC     $41
                       STA     $41
                       TXA
                       ADC     $42
                       STA     $42
                       BMI     L8A70
                       ASL     $41
                       ROL     $42
                       BMI     L8A70
                       LDA     $6A
                       AND     #$0F
                       ADC     $41
                       STA     $41
                       BCC     L8A61
                       INC     $42
                       BMI     L8A70
L8A61:                 INC     txtoff
                       LDY     txtoff
                       LDA     (txtptr),Y
                       STA     $6A
                       JSR     isdig
                       BCC     L8A36
                       TYA
L8A6F:                 RTS
L8A70:                 BRK
L8A71:                 ASC     "!"
S8A72:                 LDX     #$CF
S8A74:                 LDY     #$01
                       LDA     ($26),Y
                       BPL     L8A7C
L8A7A:                 CLC
L8A7B:                 RTS
L8A7C:                 JSR     S8A88
                       BCS     L8A7B
                       JSR     S8A14
                       BPL     L8A7C
                       BMI     L8A7A
S8A88:                 LDY     #$04
                       STX     $7D
L8A8C:                 INY
                       LDA     ($26),Y
                       JSR     S8AB2
                       BNE     L8A96
                       INY
                       INY
L8A96:                 CMP     $7D
                       BEQ     L8A7B
                       CMP     #$0D
                       BNE     L8A8C
                       BEQ     L8A7A
S8AA0:                 LDA     $26
                       STA     txtptr
                       LDA     $27
                       STA     txtptr+1
                       RTS
S8AA9:                 LDA     txtptr
                       STA     $26
                       LDA     txtptr+1
                       STA     $27
                       RTS
S8AB2:                 CMP     #$ED
                       BEQ     L8AB8
                       CMP     #$EE
L8AB8:                 RTS
S8AB9:                 CMP     #$0D
                       BEQ     L8AB8
                       CMP     #$2C
                       RTS
S8AC0:                 STY     $7D
                       PLA
                       TAX
                       PLA
                       TAY
                       LDA     $63
                       PHA
                       LDA     $62
L8ACB:                 PHA
L8ACC:                 TYA
                       PHA
                       TXA
                       PHA
                       LDX     $67
                       LDY     $7D
                       CLC
                       RTS
S8AD6:                 STY     $7D
                       PLA
                       TAX
                       PLA
                       TAY
                       PLA
                       STA     $62
                       PLA
                       STA     $63
                       JMP     L8ACC
S8AE5:                 STX     $67
                       PLA
                       TAX
                       PLA
                       TAY
                       LDA     txtoff
                       PHA
                       LDA     txtptr+1
                       PHA
                       LDA     txtptr
                       JMP     L8ACB
S8AF6:                 STX     $67
                       PLA
                       TAX
                       PLA
                       TAY
                       PLA
                       STA     txtptr
                       PLA
                       STA     txtptr+1
                       PLA
                       STA     txtoff
                       JMP     L8ACC
S8B08:                 LDY     $28
                       DEY
                       LDA     ($36),Y
                       INY
                       CMP     #$28
                       RTS
S8B11:                 JSR     LB308
                       INC     txtoff
                       RTS
S8B17:                 LDA     txtptr
                       STA     $2B
                       LDA     #$00
                       STA     $6D
                       STA     txtoff
                       TAX
                       TAY
                       LDA     txtptr+1
                       STA     $2C
                       RTS
S8B28:                 JSR     S8B17
L8B2B:                 LDA     ($2B),Y
                       CMP     #$0D
                       BEQ     L8B7E
                       CMP     #$20
                       BNE     L8B40
                       INC     txtptr
                       BNE     L8B3B
                       INC     txtptr+1
L8B3B:                 JSR     S89C4
                       BCS     L8B2B
L8B40:                 LDY     #$00
                       LDA     ($2B),Y
                       CMP     #$2A
                       BEQ     L8B50
                       CMP     #$2E
                       BNE     L8B88
                       LDA     #$F8
                       STA     ($2B),Y
L8B50:                 JSR     S89C4
                       CMP     #$0D
                       BNE     L8B50
                       TYA
                       CLC
                       ADC     $2B
                       STA     $2B
                       BCC     L8B61
                       INC     $2C
L8B61:                 DEC     $2C
                       INC     $2B
                       LDY     #$FF
L8B67:                 DEY
                       LDA     ($2B),Y
                       CMP     #$20
                       BEQ     L8B67
                       INY
                       LDA     #$0D
                       STA     ($2B),Y
                       TYA
                       CLC
                       ADC     $2B
                       SEC
                       SBC     txtoff
                       SEC
                       SBC     txtptr
                       DFB     $24          ; BIT - skips the next instruction.
L8B7E:                 TYA
                       STA     $6C
                       CLC
                       RTS
L8B83:                 JSR     S89C4
S8B86:                 LDY     #$00
L8B88:                 JSR     S8C8E
                       STA     $67
                       BCC     L8BD7
                       CMP     #$2F
                       BEQ     L8BD7
                       CMP     #$0D
                       BEQ     L8B61
                       CMP     #$26
                       BEQ     L8BB5
                       JSR     isdig
                       BCC     L8BC1
                       CMP     #$2E
                       BEQ     L8BC1
                       CMP     #$22
                       BNE     L8B83
L8BA8:                 JSR     S89C4
                       CMP     #$22
                       BEQ     L8B83
                       CMP     #$0D
                       BEQ     L8B61
                       BNE     L8BA8
L8BB5:                 JSR     S89C4
                       JSR     isxdig
                       STA     ($2B),Y
                       BCC     L8BB5
                       BCS     L8B88
L8BC1:                 JSR     S89C4
                       JSR     isdig
                       BCC     L8BC1
                       CMP     #$2E
                       BEQ     L8BC1
                       AND     #$DF
                       CMP     #$45
                       BNE     L8B88
                       STA     ($2B),Y
                       BEQ     L8BC1
L8BD7:                 LDA     #$FD
                       STA     $6D
                       LDA     #$7C
                       STA     $29
                       LDA     #$87
                       STA     $2A
L8BE3:                 LDY     #$FF
L8BE5:                 INY
                       LDA     ($2B),Y
                       JSR     islc
                       BCS     L8BEF
                       AND     #$DF
L8BEF:                 EOR     ($29),Y
                       BEQ     L8BE5
                       CMP     #$80
                       BNE     L8C3B
tknfnd:                LDA     ($2B),Y
                       JSR     S897D
                       BCS     L8C07
                       INY
                       LDA     ($2B),Y
                       JSR     S897D
                       DEY
                       BCC     L8C43
L8C07:                 LDA     $6D
                       STA     ($2B,X)
                       JSR     S8AB2
                       BNE     L8C18
                       JSR     S89C4
                       JSR     S89C4
                       DEY
                       DEY
L8C18:                 INY
                       LDA     ($2B),Y
                       CMP     #$20
                       BEQ     L8C18    
                       DEY         
                       JSR     S89C4    
                       TYA         
                       CLC         
                       ADC     $2B      
                       STA     $29      
                       LDA     #$00     
                       TAY         
                       ADC     $2C      
                       STA     $2A      
L8C30:                 LDA     ($29),Y  
                       STA     ($2B),Y  
                       INY         
                       CMP     #$0D     
                       BNE     L8C30    
                       BEQ     L8C72  
L8C3B:                 LDA     ($2B),Y
                       CMP     #$2E
                       BEQ     L8C07
                       DEY
L8C42:                 INY
L8C43:                 LDA     ($29),Y
                       BPL     L8C42
                       TYA
                       SEC
                       ADC     $29
                       STA     $29
                       BCC     L8C51
                       INC     $2A
L8C51:                 DEC     $6D
                       LDA     ($29,X)
                       BNE     L8BE3
                       LDY     #$00
                       LDA     $67
                       CMP     #$2F
                       BEQ     L8C6F
L8C5F:                 JSR     S89C4
                       JSR     S8C8E
                       BCC     L8C5F
                       JSR     S897D
                       BCC     L8C5F
                       JMP     L8B88
L8C6F:                 JMP     L8B83
L8C72:                 DEY
                       LDA     $6D
                       CMP     #$CE
                       BCC     $8C7D
                       CMP     #$D5
                       BCC     $8C88
                       CMP     #$8C
                       BEQ     $8C8B
                       CMP     #$93
                       BEQ     $8C8B
                       JMP     S8B86
                       JMP     $8B57
                       JMP     L8B40
S8C8E:                 LDA     ($2B),Y
                       JSR     islc
                       BCS     L8C99
                       ORA     #$20
                       STA     ($2B),Y
L8C99:                 RTS
cmdtab:                DFW     PSEUDO-1, PSEUDO-1, PSEUDO-1, PSEUDO-1
                       DFW     PSEUDO-1, CLEAR-1,  NULL-1,   CLG-1
                       DFW     CLS-1,    NEW-1,    STOP-1,   RESTOR-1
                       DFW     EXEC-1,   GOTO-1,   DEL-1,    NULL-1
                       DFW     NULL-1,   RUN-1,    SAVE-1,   LOAD-1
                       DFW     DELETE-1, SELECT-1, VDU-1,    DIM-1
                       DFW     COSCLI-1, OPEN-1,   INPUT-1,  WRITE-1
                       DFW     READ-1,   CLOSE-1,  DRAW-1,   GCOL-1
                       DFW     MOVE-1,   PLOT-1,   SOUND-1,  ENVELP-1
                       DFW     COLOUR-1, UNTIL-1,  END-1,    NEXT-1
                       DFW     RETURN-1, IMPORT-1, ELSE-1,   ELSE-1
                       DFW     ELSE-1,   ELSE-1,   FNPROC-1, FNPROC-1
                       DFW     CASE-1,   REPEAT-1, IF-1,     WHILE-1
                       DFW     FOR-1,    PRINT-1,  AUTO-1,   RENUM-1
                       DFW     EDIT-1,   LIST-1,   CONT-1,   DEBUG-1
                       DFW     OLD-1,    NULL-1,   NULL-1,   EXEC-1
                       DFW     NULL-1
L8D1C:                 STA     $69
                       SEC
                       SBC     #$E7
                       TAY
L8D22:                 LDA     D8F5D,Y
                       JSR     S8EBD
                       BNE     L8D35
                       DEY
                       BEQ     L8D22
L8D2D:                 LDA     #$1B
                       JSR     L8068
                       JMP     L8DD4
L8D35:                 LDA     #$E8
                       CMP     $69
                       BCS     L8D40
                       CPX     lstkp
                       BNE     L8D2D
                       CLC
L8D40:                 LDA     $6B
                       SBC     #$00
                       JMP     L8DD6
S8D47:                 LDX     pdbugd
                       BEQ     L8D4E
                       RTS
DEBUG:                 LDA     #$FF
L8D4E:                 STA     $28
                       JSR     S8582
                       JSR     S8F43
                       STX     lstkp
                       STX     $0500
                       STX     $20
                       STX     $6B
                       DEX
                       STX     pdbugd
                       LDA     #$E4
                       STA     $38
                       LDA     #$04
                       STA     $39
L8D6A:                 LDY     #$01
                       LDA     ($26),Y
                       BPL     L8D76
                       JSR     S8ECE
                       JMP     L8F6A
L8D76:                 LDX     #$E7
                       JSR     S8A88
                       BCS     L8D1C
                       LDY     #$05
                       LDA     ($26),Y
                       STA     $69
                       CMP     #$E4
                       BCC     L8DD4
                       CMP     #$E7
                       BCC     L8DE4
                       CMP     #$ED
                       BCC     L8D1C
                       CMP     #$F4
                       BCS     L8DD4
                       CMP     #$F1
                       BCC     L8DA2
                       JSR     S8EA7
                       CMP     #$8C
                       BEQ     L8DA2
                       CMP     #$93
                       BNE     L8DD4
L8DA2:                 JSR     S8AB2
                       BNE     L8DAA
                       JSR     S8ECE
L8DAA:                 LDA     lstkp
                       CLC
                       ADC     #$03
                       BCS     L8DDF
                       STA     lstkp
                       LDX     $69
                       LDA     D8F5D-$E7,X
                       ADC     $20
                       STA     $20
                       BCS     L8DDF
                       LDX     lstkp
                       LDA     $27
                       STA     $04FF,X
                       LDA     $26
                       STA     $04FE,X
                       LDA     $69
                       STA     $0500,X
                       LDA     $6B
                       INC     $6B
                       DFB     $2C          ; BIT - skips the next instruction.
L8DD4:                 LDA     $6B
L8DD6:                 LDY     #$04
                       STA     ($26),Y
                       JSR     S8A14
                       BCC     L8D6A
L8DDF:                 LDA     #$1C
                       JMP     L8068
L8DE4:                 CMP     #$E5
                       BEQ     L8E05
                       CMP     #$E6
                       BEQ     L8E1A
                       LDA     #$F0
L8DEE:                 JSR     S8DF6
                       BCS     L8DD4
                       JMP     L8E97
S8DF6:                 STA     $69
                       JSR     S8EBD
                       BEQ     L8E00
                       JMP     L8ED0
L8E00:                 LDA     #$1D
                       JMP     L8068
L8E05:                 INY
                       LDA     ($26),Y
                       JSR     S89B6
                       BNE     L8E12
                       JSR     S8ECE
                       BCC     L8DD4
L8E12:                 JSR     S8AB2
                       BNE     L8DEE
                       INY
                       INY
                       DFB     $2C          ; BIT - skips next instruction.
L8E1A:                 LDA     #$F3
                       STY     $78
                       JSR     S8DF6
                       BCS     L8DD4
                       LDY     $78
                       JSR     S8F30
                       JSR     S9026
                       LDX     lstkp
                       LDA     $04FE,X
                       STA     $26
                       LDA     $04FF,X
                       STA     $27
                       LDY     #$05
                       LDA     $69
                       JSR     S8AB2
                       BNE     L8E50
                       LDA     $26
                       INY
                       STA     ($38),Y
                       LDA     $27
                       INY
                       STA     ($38),Y
                       STA     $39
                       LDA     $26
                       STA     $38
L8E50:                 JSR     S8F1A
                       BNE     L8E5A
                       JSR     S8F09
                       BCS     L8E91
L8E5A:                 LDY     #$00
                       LDA     ($34),Y
                       JSR     S89B6
                       BNE     L8E8C
                       DEY
L8E64:                 JSR     S8F08
                       BCC     L8E64
                       TYA
                       PHA
                       JSR     S902F
                       LDY     #$03
                       CLC
                       ADC     ($26),Y
                       STA     ($26),Y
                       LDA     $34
                       STA     $26
                       LDA     $35
                       STA     $27
                       PLA
                       JSR     S84A7
                       LDY     #$FF
L8E83:                 JSR     S8F08
                       BCS     L8E91
                       STA     ($26),Y
                       BCC     L8E83
L8E8C:                 LDA     #$19
                       JSR     S8065
L8E91:                 JSR     S8582
                       JSR     S902F
L8E97:                 DEC     lstkp
                       DEC     lstkp
                       DEC     lstkp
                       DEC     $6B
                       LDX     $69
                       JSR     S8EB4
                       JMP     L8DD4
S8EA7:                 LDX     #$CE
                       JSR     S8A88
L8EAC:                 DEY
                       LDA     ($26),Y
                       CMP     #$20
                       BEQ     L8EAC
                       RTS
S8EB4:                 LDA     $20
                       SEC
                       SBC     D8F5D-$E7,X
                       STA     $20
                       RTS
S8EBD:                 LDX     lstkp
                       BEQ     L8ECB
L8EC1:                 CMP     $0500,X
                       BEQ     L8ECC
                       DEX
                       DEX
                       DEX
                       BNE     L8EC1
L8ECB:                 RTS
L8ECC:                 TXA
                       RTS
S8ECE:                 LDX     #$00
L8ED0:                 STX     $77
L8ED2:                 CPX     lstkp
                       BCS     L8EF9
                       INX
                       INX
                       INX
                       TXA
                       PHA
                       LDA     $04FE,X
                       STA     txtptr
                       LDA     $04FF,X
                       STA     txtptr+1
                       LDA     $0500,X
                       TAX
                       JSR     S8EB4
                       LDA     $28
                       BEQ     L8EF3
                       JSR     S81C1
L8EF3:                 DEC     $6B
                       PLA
                       TAX
                       BCS     L8ED2
L8EF9:                 CPX     $77
                       BEQ     L8F02
                       LDA     #$18
                       JSR     L8068
L8F02:                 LDA     $77
                       STA     lstkp
L8F06:                 CLC
                       RTS
S8F08:                 INY
S8F09:                 LDA     ($29),Y
                       JSR     S897D
                       BCC     L8F06
                       CMP     #$23
                       BEQ     L8F06
                       CMP     #$24
                       BEQ     L8F06
                       SEC
                       RTS
S8F1A:                 JSR     S8F33
                       LDY     #$FF
L8F1F:                 INY
                       LDA     ($34),Y
                       CMP     #$20
                       BEQ     L8F2F
                       JSR     S89B6
                       BEQ     L8F2F
                       CMP     ($29),Y
                       BEQ     L8F1F
L8F2F:                 RTS
S8F30:                 LDX     #$34
                       DFB     $2C          ; BIT - skips the next instruction.
S8F33:                 LDX     #$29
                       INY
                       TYA
                       CLC
                       ADC     $26
                       STA     $00,X
                       LDA     $27
                       ADC     #$00
                       STA     $01,X
                       RTS
S8F43:                 LDX     #$26
                       DFB     $2C          ; BIT - skips the next instruction.
S8F46:                 LDX     #$13
                       LDA     page+1
                       STA     $01,X
                       LDA     #$00
                       STA     $00,X
                       LDX     #$00
                       RTS
S8F53:                 LDA     $26
                       SEC
                       SBC     $34
                       LDA     $27
                       SBC     $35
                       RTS
D8F5D:                 DFB     $ED, $EE, $EF, $F1, $EF, $F1, $02, $02 ; ........
                       DFB     $00, $02, $00, $02, $0F                ; .....
L8F6A:                 JSR     S8F43
                       TXA
                       LDY     #$07
                       STA     ($38),Y
L8F72:                 LDX     #$CC
                       JSR     S8A74
                       BCS     L8F9E
                       JSR     S8F43
L8F7C:                 LDX     #$CA
                       JSR     S8A74
                       BCS     L8F86
                       JMP     LAA63
L8F86:                 INY
                       LDA     ($26),Y
                       JSR     S89B6
                       BEQ     L8F99
                       JSR     S8FEC
                       BCS     L8F96
                       JSR     S8065
L8F96:                 JSR     S902F
L8F99:                 JSR     S8A14
                       BCC     L8F7C
L8F9E:                 JSR     S8FEC
                       BCS     L8FB1
                       DFB     $2C
L8FA4:                 LDA     #$1E
                       JSR     S8065
L8FA9:                 JSR     S902F
                       JSR     S8A14
                       BCC     L8F72
L8FB1:                 JSR     S8F53
                       BCC     L8FC3
                       LDA     $26
                       STA     $34
                       LDA     $27
                       STA     $35
                       JSR     S902F
                       BCS     L8FCB
L8FC3:                 LDA     $3C
                       STA     $34
                       LDA     $3D
                       STA     $35
L8FCB:                 LDY     #$04
                       LDA     ($26),Y
                       STA     $6B
L8FD1:                 JSR     S8A14
                       LDY     #$04
                       LDA     ($26),Y
                       CMP     $6B
                       BCC     L8FA4
                       JSR     S8F53
                       BCC     L8FD1
                       LDA     ($26),Y
                       CMP     $6B
                       BNE     L8FA4
                       BEQ     L8FA9
S8FE9:                 JSR     S8AA9
S8FEC:                 JSR     S9026
                       LDX     #$CC
                       DFB     $2C          ; BIT - skips the next instruction.
L8FF2:                 LDX     #$CA
                       JSR     S8A88
                       BCC     L8FF2
                       JSR     S8F30
                       JSR     S8F43
L8FFF:                 LDX     #$FF
                       JSR     S8A74
                       BCS     L9009
L9006:                 LDA     #$20
                       RTS
L9009:                 JSR     S8F1A
                       BNE     L9014
                       LDA     ($29),Y
                       CMP     #$3A
                       BEQ     L9025
L9014:                 JSR     S8A14
                       BPL     L8FFF
                       BCC     L9006
GOTO:                  JSR     S8FE9
                       JSR     S8AA0
                       LDX     #$FB
                       TXS
                       CLC
L9025:                 RTS
S9026:                 LDA     $26
                       STA     $3C
                       LDA     $27
                       STA     $3D
                       RTS
S902F:                 LDY     $3C
                       STY     $26
                       LDY     $3D
                       STY     $27
                       RTS
toknos:                DFB     $21, $22, $2A, $2B, $3F, $40, $61, $7B ; !"*+?@a{
                       DFB     $BF, $C4, $C9, $CA, $CB, $CC, $CD, $CE ; ........
                       DFB     $CF, $D0, $D1, $D3, $D5, $D6, $D7, $D8 ; ........
                       DFB     $D9, $DA, $DB, $DC, $DD, $E0, $E1, $E2 ; ........
                       DFB     $E3, $E4, $E5, $E6, $E7, $E8, $E9, $EB ; ........
                       DFB     $EC, $ED, $EE, $EF, $F0, $F1, $F2, $F3 ; ........
                       DFB     $F4, $F5, $F9, $FC, $FE, $00           ; ......
D906E:                 DFB     $9D, $40, $D0, $CF, $D0, $40, $D0, $0C ; .@...@..
                       DFB     $D0, $BD, $9D, $9D, $17, $32, $5E, $4E ; .....2^N
                       DFB     $CF, $6D, $0B, $58, $58, $59, $61, $4D ; .m.XXYaM
                       DFB     $52, $B9, $5D, $03, $07, $6F, $6F, $6F ; R.]..ooo
                       DFB     $6F, $6F, $6F, $E4, $22, $5F, $6E, $9D ; ooo."_n.
                       DFB     $91, $5A, $B4, $B0, $44, $9D, $57, $4A ; .Z..D.WJ
                       DFB     $4B, $08, $05, $9D, $D0, $CF           ; K.....
D90A4:                 DFB     $E0, $F0, $00, $F0, $00, $F0, $00, $E0 ; ........
                       DFB     $00, $F0, $F0, $D0, $70, $F0, $50, $90 ; ....p.P.
                       DFB     $E0, $50, $F0, $90, $F0, $F0, $D0, $F0 ; .P......
                       DFB     $F0, $F0, $F0, $F0, $F0, $E2, $E3, $E4 ; ........
                       DFB     $EE, $E1, $41, $50, $50, $70, $50, $50 ; ..APPpPP
                       DFB     $50, $50, $50, $50, $50, $50, $D0, $D0 ; PPPPPP..
                       DFB     $D0, $F0, $90, $90, $FF, $40, $3D, $3E ; .....@=>
                       DFB     $3C, $2B, $2D, $2A, $2F, $86, $88, $5E ; <+-*/..^
                       DFB     $3F, $21, $85, $89, $87                ; ?!...
tkadlo:                DFB     $34, $47, $47, $88, $88, $3D, $3D, $8C ; 4GG..==.
                       DFB     $88, $20, $20, $9D, $49, $39, $42, $28 ; .  .I9B(
                       DFB     $A8, $3F, $1D, $47, $47, $2F, $E8, $31 ; .?.GG/.1
                       DFB     $42, $6C, $42, $34, $34, $75, $2F, $3D ; BlB44u/=
                       DFB     $47, $34, $3F, $E5, $E5, $34, $3F, $31 ; G4?..4?1
                       DFB     $3F, $2F, $47, $2F, $C4, $3F, $2F, $9C ; ?/G/.?/.
                       DFB     $31, $CD, $31, $36, $31, $3D, $97, $18 ; 1.161=..
                       DFB     $47, $31, $3F, $47, $47, $CC, $2F, $31 ; G1?GG./1
                       DFB     $97, $47, $34, $47, $20, $2F, $75, $15 ; .G4G /u.
                       DFB     $47, $32, $47, $3F, $47, $2F, $3D, $76 ; G2G?G/=v
                       DFB     $2F, $47, $8C, $47, $1E, $2F, $47, $47 ; /G.G./GG
                       DFB     $1E, $47, $47, $47, $47                ; .GGGG
tkadhi:                DFB     $88, $31, $20, $3D, $6D, $76, $A4, $09 ; .1 =mv..
                       DFB     $15, $06, $A0, $DB, $7F, $7F, $9C, $57 ; .......W
                       DFB     $70, $73, $C5, $A9, $79, $03, $03, $92 ; ps..y...
                       DFB     $53, $AA, $21, $21, $2E, $C1, $8A, $8A ; S.!!....
                       DFB     $3A, $8F, $3A, $94, $2C, $2C, $29, $28 ; :.:.,,)(
                       DFB     $3A, $29, $29, $8D, $3A, $29, $0D, $8D ; :)).:)..
                       DFB     $BE, $2E, $2C, $3B, $8A                ; ..,;.
D917B:                 DFB     $C9, $CC, $8E, $2C, $2C, $28, $A4, $90 ; ...,,(..
                       DFB     $FD, $2C, $28, $CE, $BD, $2B, $A1, $A2 ; .,(..+..
                       DFB     $A3, $2C, $DB, $92, $3A, $3A, $26, $2C ; .,..::&,
                       DFB     $2C, $95, $DA, $8B, $FC, $91, $7F, $37 ; ,......7
                       DFB     $9D, $12, $7F, $4F, $D9, $D9, $C4, $F4 ; ...O....
                       DFB     $87, $87, $7D, $92, $21, $92, $72, $5D ; ..}.!.r]
                       DFB     $D9, $CD, $D9, $E5, $F4, $69, $AD, $C7 ; .....i..
                       DFB     $B3, $B3, $BB, $C1, $67, $67, $65, $6C ; ....ggel
                       DFB     $E8, $DC, $E8, $E9, $ED, $20, $CC, $37 ; ..... .7
                       DFB     $C9, $C9, $28, $3A, $23, $29, $2C, $2C ; ..(:#),,
                       DFB     $29, $28, $EF, $2B, $2D, $24, $28, $28 ; )(.+-$((
                       DFB     $2E, $45, $23, $28, $F1, $F2, $EE, $29 ; .E#(...)
                       DFB     $ED, $94, $94, $94, $95, $96, $95, $93 ; ........
                       DFB     $95, $96, $96, $95, $96, $94, $94, $95 ; ........
                       DFB     $95, $94, $95, $95, $95, $95, $94, $95 ; ........
                       DFB     $95, $95, $94, $96, $95, $00, $96, $96 ; ........
                       DFB     $95, $94, $94, $00, $95, $95, $95, $95 ; ........
                       DFB     $95, $95, $95, $95, $95, $94, $94, $94 ; ........
                       DFB     $00, $95, $95, $94, $94, $94, $94, $94 ; ........
                       DFB     $94, $94, $94, $94, $00, $00, $00, $00 ; ........
                       DFB     $00, $00, $00, $00, $00, $00, $00      ; .......
D9222:                 DFB     $D5, $95, $BC, $62, $62, $A9, $9D, $9D ; ...bb...
                       DFB     $09, $BA, $BB, $CF, $CF, $B3, $B1, $CF ; ........
                       DFB     $CF, $D3, $CF, $A7, $86, $2C, $9D, $9D ; .....,..
                       DFB     $CF, $9F, $CF, $E8, $94, $CF, $CF, $EA ; ........
                       DFB     $CF, $D6, $9D, $97, $24, $9D, $9D, $9D ; ....$...
                       DFB     $D4, $C2, $A6, $A3, $29, $D6, $CF, $9F ; ....)...
                       DFB     $D6, $DA, $16, $C2, $E7, $EB, $C3, $E3 ; ........
                       DFB     $8F, $DD, $E9, $9B, $89, $D8, $8A, $EC ; ........
                       DFB     $BE, $83, $D2, $90, $64, $90, $BD, $C1 ; ....d...
                       DFB     $86, $65, $66, $77, $95, $9D, $96, $BB ; .efw....
                       DFB     $A3, $80, $81, $AF, $82, $7D, $66, $72 ; .....}fr
                       DFB     $9D, $BC, $73, $AE, $9D, $62, $9D, $9D ; ..s..b..
                       DFB     $9D, $9D, $9D, $F1, $9D, $CF, $B5, $CF ; ........
                       DFB     $CF, $27, $25, $97, $CF, $9D, $CF, $9D ; .'%.....
                       DFB     $CF, $87, $92, $9D, $97, $CF, $F1, $51 ; .......Q
                       DFB     $45, $43, $DE, $29, $CF, $0A, $5B, $62 ; EC.)..[b
                       DFB     $53, $54, $A4, $CF, $13, $48, $CF, $9A ; ST...H..
                       DFB     $3B, $CF, $CF                          ; ;..
D92AD:                 DFB     $CF, $47, $38, $35, $41, $0E, $2B, $9D ; .G85A.+.
                       DFB     $5E, $47, $B6, $60, $41, $9C, $37, $CF ; ^G.`A.7.
                       DFB     $3C, $3E, $CF, $76, $2F, $CF, $9C, $9C ; <>.v/...
                       DFB     $B8, $9D, $4F, $47, $14, $CA, $06, $60 ; ..OG...`
                       DFB     $55, $9D, $9D, $9D, $56, $30, $45, $D0 ; U...V0E.
                       DFB     $CF, $21, $67, $4C, $01, $50, $7F, $09 ; .!gL.P..
                       DFB     $0A, $02, $40, $43, $40, $97, $47, $33 ; ..@C@.G3
                       DFB     $36, $CF, $3D, $CF, $CF, $F1, $CF, $CB ; 6.=.....
                       DFB     $CB, $CF, $CF, $CF, $CF, $D0, $78, $CF ; ......x.
                       DFB     $BD, $CF, $94, $9D, $E1, $D8, $D7, $DA ; ........
                       DFB     $DB, $C8, $9D, $D0, $CF, $E0, $D7, $CF ; ........
                       DFB     $E0, $9D, $CF, $CF, $CF, $D7, $63, $35 ; ......c5
                       DFB     $C5, $CF, $71, $9D, $9D, $69, $CF, $6A ; ..q..i.j
D9315:                 DFB     $3A, $2B, $9D, $62, $62, $AA, $9D, $9D ; :+.bb...
                       DFB     $AB, $BA, $A5, $58, $0D, $0E, $11, $10 ; ...X....
                       DFB     $98, $BF, $C0, $85, $86, $33, $9D, $9D ; .....3..
                       DFB     $28, $CE, $C6, $6B, $7A, $C7, $70, $8E ; (..kz.p.
                       DFB     $2E, $2D, $9D, $74, $1F, $26, $9D, $9D ; .-.t.&..
                       DFB     $9D, $B7, $93, $B5, $CF, $9D, $9D, $0F ; ........
                       DFB     $A1, $1C, $CE, $89, $A0, $8B, $8D, $19 ; ........
                       DFB     $1A, $A2, $12, $9D, $AC, $BB, $CF, $86 ; ........
                       DFB     $24, $9D, $9D, $0A, $AD, $7E, $9D, $66 ; $....~.f
                       DFB     $30, $D1, $67, $CE, $21, $B2, $4C, $01 ; 0.g.!.L.
                       DFB     $50, $04, $9D, $9D, $9D, $BE, $79, $46 ; P.....yF
                       DFB     $23, $CF, $CF, $CF, $7C, $3D, $1B, $9E ; #...|=..
                       DFB     $D0, $D0, $D0, $CF, $D0, $D0, $CF, $CF ; ........
                       DFB     $D0, $78, $CE, $BD, $CE, $94, $D0, $D9 ; .x......
                       DFB     $CF, $E1, $CF, $EC, $D0, $D0, $DB, $D0 ; ........
                       DFB     $DF, $E2, $D0, $CF, $EE, $E6, $D0, $D0 ; ........
                       DFB     $D0, $D0, $EB, $CF, $CF, $9A, $EF, $F0 ; ........
                       DFB     $F2, $D0, $9D, $20, $CD, $89, $20, $3F ; ... .. ?
                       DFB     $96, $A9, $20, $39, $A4, $90, $F0, $02 ; .. 9....
                       DFB     $D0, $10                               ; ..
L93AF:                 LDA     #$1B
                       STA     erflag
                       SEC
                       RTS
S93B5:                 LDA     #$16
                       STA     erflag
                       JSR     LB308
                       JSR     S963F
                       LDA     $3E
                       AND     D90A4,Y
                       BEQ     L93AF
                       LDA     D90A4,Y
                       AND     #$10
                       BEQ     L93CF
                       INC     txtoff
L93CF:                 LDA     D906E,Y
L93D2:                 TAY
S93D3:                 LDA     txtoff
                       PHA
                       TYA
                       PHA
                       LDY     txtoff
                       LDA     (txtptr),Y
                       STA     $6A
                       PLA
                       PHA
                       TAY
                       TSX
                       CPX     #$20
                       BCS     L93EE
                       LDA     #$1C
                       STA     erflag
                       SEC
                       PLA
                       PLA
                       RTS
L93EE:                 CPY     #$C8
                       BCS     L93F5
                       JSR     LB308
L93F5:                 TAY
                       LDA     tkadlo,Y
                       STA     $34
                       LDA     $6A
                       LDX     D917B,Y
                       CPY     #$61
                       BCC     L945D
                       CPY     #$7B
                       BCC     L9413
                       CPY     #$B0
                       BCC     L9454
                       CPY     #$DC
                       BCS     L9454
                       LDX     tkadhi,Y
L9413:                 STX     $35
                       BEQ     L945D
                       DEX
                       BEQ     L9454
                       JSR     S944B
L941D:                 LDA     #$00
                       ROR     
L9420:                 STA     $7E
                       PLA
                       TAY
                       PLA
                       LDX     $7E
                       BEQ     L944E
                       CPY     #$90
                       BCS     L9435
                       CPY     #$28
                       BCC     L943A
                       LDX     #$D0
                       BCS     L943D
L9435:                 LDX     D92AD,Y
                       BCS     L943D
L943A:                 LDX     D9315,Y
L943D:                 CPX     #$CF
                       BEQ     L9447
                       CPX     #$D0
                       BEQ     L9447
                       STA     txtoff
L9447:                 TXA
                       JMP     L93D2
S944B:                 JMP     ($0034)
L944E:                 LDX     D9222,Y
                       JMP     L9447
L9454:                 SEC
                       SBC     $34
                       BNE     L9420
                       INC     txtoff
                       BNE     L9420
L945D:                 LDY     $34
                       JSR     S93D3
                       JMP     L941D
                       SEC
                       BIT     $18
                       PLA
                       PLA
                       PLA
                       PLA
                       RTS
                       LDY     #$00
                       BIT     $68A0
                       BIT     $37A0
                       BIT     $18A0
                       BIT     $99A0
                       LDX     #$FF
                       DEC     txtoff
                       TYA
                       PHA
                       TXA
                       BEQ     $94A0
                       INC     txtoff
                       PHA
                       JSR     S93D3
                       BCS     $949C
                       JSR     LB308
                       PLA
                       TAX
                       PLA
                       TAY
                       DEX
                       LDA     $6A
                       CMP     #$2C
                       BEQ     $947F
                       CLC
                       RTS
                       PLA
                       TAX
                       SEC
                       BIT     $18
                       PLA
                       TAY
                       RTS
                       LDX     #$08
                       LDY     #$2A
                       BNE     $947D
                       LDX     #$02
                       BIT     $08A2
                       LDY     #$47
                       BNE     $947D
                       JSR     isxdig
                       BCS     $94BA
                       INC     txtoff
                       RTS
                       JSR     isdig
                       JMP     $94B6
                       JSR     islc
                       JMP     $94B6
                       JSR     S897D
                       JMP     $94B6
                       LDY     #$08
                       CMP     $90DD,Y
                       BEQ     $952A
                       DEY
                       BPL     $94CF
                       SEC
                       RTS
                       LDA     #$02
                       JSR     LB308
                       STY     $2C
                       TAX
                       LDA     (txtptr),Y
                       CMP     $90DA,X
                       BNE     $94ED
                       INY
                       CPX     #$03
                       BCS     $94F1
                       DEX
                       BPL     $94E1
                       INX
                       TYA
                       SEC
                       SBC     $2C
                       BEQ     $94FE
                       CMP     #$03
                       BCS     $94FE
                       JMP     $BCEC
                       JSR     $BCEC
                       SEC
                       RTS
                       LDA     #$93
                       BIT     $8CA9
                       BIT     $8EA9
                       CMP     $6A
                       BEQ     $952A
                       JMP     $961B
                       CMP     #$3A
                       BNE     $9501
                       LDY     txtoff
                       INY
                       LDA     (txtptr),Y
                       CMP     #$3D
                       BNE     $9501
                       BEQ     $9540
                       CMP     #$3D
                       BNE     $9512
                       LDA     #$96
                       JSR     $9622
                       INC     txtoff
                       CLC
                       RTS
                       LDY     txtoff
                       INY
                       LDA     (txtptr),Y
                       CMP     #$2D
                       BEQ     $9540
                       LDY     txtoff
                       INY
                       LDA     (txtptr),Y
                       CMP     #$2B
                       BNE     $9501
                       DEY
                       LDA     (txtptr),Y
                       CMP     #$3A
                       BNE     $9501
                       LDA     #$96
                       STA     (txtptr),Y
                       INC     txtoff
                       BNE     $952A
                       LDA     $3E
                       ASL     
                       RTS
                       CMP     #$C4
                       BCS     $9552
                       CMP     #$BF
                       BCS     $952A
                       SEC
                       RTS
                       LDX     #$02
                       CMP     $90E6,X
                       BEQ     $952A
                       DEX
                       BPL     $955F
                       SEC
                       RTS
                       CMP     #$97
                       BCC     $959A
                       CMP     #$A1
                       BCC     $952A
                       RTS
                       CMP     #$A5
                       BCC     $9501
                       CMP     #$BA
                       BCS     $9501
                       JMP     SB304
                       CMP     #$2C
                       BEQ     $952A
                       CMP     #$3B
                       BEQ     $952A
                       SEC
                       RTS
                       JSR     $957D
                       BCC     $9586
                       CMP     #$27
                       BEQ     $952A
                       SEC
                       RTS
                       CMP     #$3F
                       BEQ     $952A
                       CMP     #$21
                       BEQ     $952A
                       SEC
                       RTS
                       CMP     #$7E
                       BEQ     $952A
                       CMP     #$BA
                       BCC     $959A
                       CMP     #$BD
                       BCC     $952A
                       RTS
                       JSR     $95C0
                       BIT     $15E6
                       LDY     txtoff
                       LDA     (txtptr),Y
                       CMP     #$20
                       BEQ     $95C0
                       CMP     #$22
                       BEQ     $9598
                       JSR     S8AB9
                       BNE     $95AD
                       LDA     #$22
                       JMP     $9622
                       INC     txtoff
                       JSR     S963F
                       LDA     D90A4,Y
                       AND     #$0F
                       TAX
                       LDY     #$47
                       JSR     $947D
                       CPX     #$00
                       BNE     $95F2
                       CLC
                       RTS
                       LDY     txtoff
                       CMP     #$22
                       BEQ     $95FA
                       LDX     #$FF
                       BIT     $C8
                       INX
                       LDA     (txtptr),Y
                       JSR     S8AB9
                       BNE     $95E4
                       STY     txtoff
                       TXA
                       BNE     $95D9
                       SEC
                       RTS
                       CMP     #$22
                       BNE     L9653
                       LDY     txtoff
                       INY
                       LDA     (txtptr),Y
                       CMP     #$22
                       BEQ     $9607
                       CMP     #$0D
                       BNE     $95FA
                       SEC
                       RTS
                       INY
                       LDA     (txtptr),Y
                       CMP     #$22
                       BEQ     $95FA
                       STY     txtoff
                       CLC
                       RTS
                       LDX     #$FF
                       BIT     $FEA2
                       LDY     #$00
                       BEQ     $9625
                       PHA
                       LDA     #$20
                       JSR     $9622
                       PLA
                       TAX
                       LDY     txtoff
                       TYA
                       PHA
                       LDA     (txtptr),Y
                       PHA
                       TXA
                       STA     (txtptr),Y
                       PLA
                       INY
                       TAX
                       CMP     #$0D
                       BNE     $9627
                       STA     (txtptr),Y
                       PLA
                       TAY
                       INY
                       INC     $6C
                       INC     txtoff
                       CLC
                       RTS
S963F:                 LDA     $6A
                       LDY     #$00
L9643:                 CMP     toknos,Y
                       BCC     L9655
                       LDX     toknos,Y
                       BEQ     L9655
                       INY
                       BNE     L9643
                       BCS     L9653
                       DEY
L9653:                 SEC
                       RTS
L9655:                 CLC
                       RTS
                       LDA     txtoff
                       PHA
                       TAY
                       LDA     (txtptr),Y
                       LDY     #$84
                       CMP     #$01
                       BEQ     $9679
                       JSR     S93D3
                       PLA
                       BCS     $9676
                       LDX     txtoff
                       STA     txtoff
                       INX
                       TXA
                       PHA
                       LDA     #$01
                       JSR     $9622
                       PLA
                       STA     txtoff
                       RTS
                       PLA
                       INC     txtoff
                       JMP     S93D3
                       INC     txtoff
                       JMP     $952A
L9684:                 BRK
L9685:                 DFB     $21                                    ; !
S9686:                 JSR     SB2EB
                       LDA     $44
                       PHA
                       JSR     SA3CE
                       JSR     SA4BA
                       INC     txtoff
                       JSR     expr6
                       JSR     SB2EB
                       LDX     #$52
                       JSR     SA4ED
                       PLA
                       STA     $51
                       EOR     $44
                       STA     $50
                       JSR     SA3CE
                       LDY     #$00
                       STY     $56
                       STY     $57
                       STY     $58
                       STY     $59
                       JSR     SBA54
                       BEQ     L9684
                       LDY     #$20
L96BA:                 DEY
                       BEQ     L96FE
                       ASL     $52
                       ROL     $53
                       ROL     $54
                       ROL     $55
                       BPL     L96BA
L96C7:                 ROL     $52
                       ROL     $53
                       ROL     $54
                       ROL     $55
                       ROL     $56
                       ROL     $57
                       ROL     $58
                       ROL     $59
                       SEC
                       LDA     $56
                       SBC     $41
                       PHA
                       LDA     $57
                       SBC     $42
                       PHA
                       LDA     $58
                       SBC     $43
                       TAX
                       LDA     $59
                       SBC     $44
                       BCC     L96F9
                       STA     $59
                       STX     $58
                       PLA
                       STA     $57
                       PLA
                       STA     $56
                       BCS     L96FB
L96F9:                 PLA
                       PLA
L96FB:                 DEY
                       BNE     L96C7
L96FE:                 RTS
L96FF:                 JSR     S9C33
                       LDY     #$00
                       LDA     $54
                       AND     #$80
                       STA     $54
                       LDA     $45
                       AND     #$80
                       CMP     $54
                       BNE     L9730
                       LDA     $56
                       CMP     $47
                       BNE     L9731
                       LDA     $57
                       CMP     $48
                       BNE     L9731
                       LDA     $58
                       CMP     $49
                       BNE     L9731
                       LDA     $59
                       CMP     $4A
                       BNE     L9731
                       LDA     $5A
                       CMP     $4B
                       BNE     L9731
L9730:                 RTS
L9731:                 ROR     
                       EOR     $54
                       ROL     
                       LDA     #$01
                       RTS
S9738:                 PHP
                       LDA     #$03
                       JSR     L9753
                       PLP
                       RTS
S9740:                 LDY     #$00
                       LDA     (aestkp),Y
                       STA     $4F
                       BEQ     L9753
                       TAY
L9749:                 LDA     (aestkp),Y
                       STA     $05FF,Y
                       DEY
                       BNE     L9749
                       LDA     $4F
L9753:                 SEC
                       DFB     $24          ; BIT - skip the next instruction.
S9755:                 CLC
                       ADC     aestkp
                       STA     aestkp
                       BCC     L975F
                       INC     aestkp+1
                       CLC
L975F:                 RTS
S9760:                 LDA     $44
                       PHA
                       JSR     SA3CE
                       LDX     #$52
                       JSR     SA522
                       JSR     SA4D5
                       PLA
                       EOR     $44
                       STA     $50
                       JSR     SA3CE
                       LDY     #$00
                       LDX     #$00
                       STY     $58
                       STY     $59
L977E:                 LSR     $53
                       ROR     $52
                       BCC     L9799
                       CLC
                       TYA
                       ADC     $41
                       TAY
                       TXA
                       ADC     $42
                       TAX
                       LDA     $58
                       ADC     $43
                       STA     $58
                       LDA     $59
                       ADC     $44
                       STA     $59
L9799:                 ASL     $41
                       ROL     $42
                       ROL     $43
                       ROL     $44
                       LDA     $52
                       ORA     $53
                       BNE     L977E
                       STY     $56
                       STX     $57
                       LDA     $50
S97AD:                 LDX     #$56
S97AF:                 PHA
                       JSR     SA432
                       PLA
                       BPL     L975F
                       JMP     SA3D6
L97B9:                 BPL     L97C2
                       LDA     #$2D
                       STA     $45
                       JSR     L994D
L97C2:                 LDA     $47
                       CMP     #$81
                       BCS     L980F
                       JSR     S9AD7
                       DEC     $4E
                       JMP     L97C2
S97D0:                 JSR     SB2F1
                       LDX     $0402
                       CPX     #$03
                       BCC     L97DC
                       LDX     #$00
L97DC:                 STX     $50
                       LDA     $0401
                       BEQ     L97E9
                       CMP     #$0A
                       BCS     S97ED
                       BCC     L97EF
L97E9:                 CPX     #$02
                       BEQ     L97EF
S97ED:                 LDA     #$0A
L97EF:                 STA     $51
                       STA     $66
                       LDA     #$00
                       STA     $4F
                       STA     $4E
                       JSR     S9ABD
                       BNE     L97B9
                       LDA     $50
                       BNE     L9807
                       LDA     #$30
                       JMP     L994D
L9807:                 JMP     L9886
L980A:                 JSR     S9F63
                       BNE     L981E
L980F:                 CMP     #$84
                       BCC     L9823
                       BNE     L981B
                       LDA     $48
                       CMP     #$A0
                       BCC     L9823
L981B:                 JSR     S9B30
L981E:                 INC     $4E
                       JMP     L97C2
L9823:                 LDA     $4C
                       STA     $40
                       JSR     S9C68
                       LDA     $66
                       STA     $51
                       LDX     $50
                       CPX     #$02
                       BNE     L9846
                       ADC     $4E
                       BMI     L988A
                       STA     $51
                       CMP     #$0B
                       BCC     L9846
                       LDA     #$0A
                       STA     $51
                       LDA     #$00
                       STA     $50
L9846:                 JSR     S9F54
                       LDA     #$A0
                       STA     $48
                       LDA     #$83
                       STA     $47
                       LDX     $51
                       BEQ     L985B
L9855:                 JSR     S9B30
                       DEX
                       BNE     L9855
L985B:                 JSR     SA0B1
                       JSR     S9C33
                       LDA     $40
                       STA     $5B
                       JSR     S9DCD
L9868:                 LDA     $47
                       CMP     #$84
                       BCS     L987C
                       ROR     $48
                       ROR     $49
                       ROR     $4A
                       ROR     $4B
                       ROR     $4C
                       INC     $47
                       BNE     L9868
L987C:                 LDA     $48
                       CMP     #$A0
                       BCS     L980A
                       LDA     $51
                       BNE     L9897
L9886:                 CMP     #$01
                       BEQ     L98D0
L988A:                 JSR     S9F54
                       LDA     #$00
                       STA     $4E
                       LDA     $66
                       STA     $51
                       INC     $51
L9897:                 LDA     #$01
                       CMP     $50
                       BEQ     L98D0
                       LDY     $4E
                       BMI     L98AD
                       CPY     $51
                       BCS     L98D0
                       LDA     #$00
                       STA     $4E
                       INY
                       TYA
                       BNE     L98D0
L98AD:                 LDA     $50
                       CMP     #$02
                       BEQ     L98B9
                       LDA     #$01
                       CPY     #$FF
                       BNE     L98D0
L98B9:                 LDA     #$30
                       JSR     L994D
                       LDA     #$2E
                       JSR     L994D
                       LDA     #$30
L98C5:                 INC     $4E
                       BEQ     L98CE
                       JSR     L994D
                       BNE     L98C5
L98CE:                 LDA     #$80
L98D0:                 STA     $66
L98D2:                 JSR     S9927
                       DEC     $66
                       BNE     L98DE
                       LDA     #$2E
                       JSR     L994D
L98DE:                 DEC     $51
                       BNE     L98D2
                       LDY     $50
                       DEY
                       BEQ     L98FF
                       DEY
                       BEQ     L98FB
                       LDY     $4F
L98EC:                 DEY
                       LDA     $0600,Y
                       CMP     #$30
                       BEQ     L98EC
                       CMP     #$2E
                       BEQ     L98F9
                       INY
L98F9:                 STY     $4F
L98FB:                 LDA     $4E
                       BEQ     L9926
L98FF:                 LDA     #$45
                       JSR     L994D
                       LDA     $4E
                       BPL     L9912
                       LDA     #$2D
                       JSR     L994D
                       SEC
                       LDA     #$00
                       SBC     $4E
L9912:                 JSR     S9939
                       LDA     $50
                       BEQ     L9926
                       LDA     #$20
                       LDY     $4E
                       BMI     L9922
                       JSR     L994D
L9922:                 CPX     #$00
                       BEQ     L994D
L9926:                 RTS
S9927:                 LDA     $48
                       LSR     
                       LSR     
                       LSR     
                       LSR     
                       JSR     S994B
                       LDA     $48
                       AND     #$0F
                       STA     $48
                       JMP     L9A7A
S9939:                 LDX     #$FF
                       SEC
L993C:                 INX
                       SBC     #$0A
                       BCS     L993C
                       ADC     #$0A
                       PHA
                       TXA
                       BEQ     L994A
                       JSR     S994B
L994A:                 PLA
S994B:                 ORA     #$30
L994D:                 STX     $67
                       LDX     $4F
                       STA     $0600,X
                       LDX     $67
                       INC     $4F
                       RTS
L9959:                 CLC
                       STX     $4C
                       JSR     S9ABD
                       LDA     #$FF
                       RTS
S9962:                 LDA     (txtptr),Y
S9964:                 CMP     #$3A
                       BCS     L996B
                       SBC     #$2F
                       DFB     $24          ; BIT - skips the next instruction.
L996B:                 CLC
                       RTS
S996D:                 LDX     #$07
                       LDA     #$00
L9971:                 STA     $47,X
                       DEX
                       BNE     L9971
                       LDY     txtoff
                       LDA     (txtptr),Y
                       CMP     #$2E
                       BEQ     L998C
                       JSR     S9962
                       BCC     L9959
                       STA     $4C
L9985:                 INY
                       LDA     (txtptr),Y
                       CMP     #$2E
                       BNE     L9994
L998C:                 LDA     $4D
                       BNE     L99D5
                       INC     $4D
                       BNE     L9985
L9994:                 CMP     #$45
                       BEQ     L99CE
                       CMP     #$65
                       BEQ     L99CE
                       JSR     S9964
                       BCC     L99D5
                       LDX     $48
                       CPX     #$18
                       BCC     L99AF
                       LDX     $4D
                       BNE     L9985
                       INC     $4E
                       BCS     L9985
L99AF:                 LDX     $4D
                       BEQ     L99B5
                       DEC     $4E
L99B5:                 JSR     L9A7A
                       ADC     $4C
                       STA     $4C
                       BCC     L9985
                       INC     $4B
                       BNE     L9985
                       INC     $4A
                       BNE     L9985
                       INC     $49
                       BNE     L9985
                       INC     $48
                       BNE     L9985
L99CE:                 JSR     S9A2D
                       ADC     $4E
                       STA     $4E
L99D5:                 STY     txtoff
                       LDA     $4E
                       ORA     $4D
                       BEQ     L9A0C
                       JSR     S9ABD
                       BEQ     L9A08
L99E2:                 LDA     #$A8
                       STA     $47
                       LDA     #$00
                       STA     $46
                       STA     $45
                       JSR     L9BE8
                       LDA     $4E
                       BMI     L99FE
                       BEQ     L9A05
L99F5:                 JSR     S9AD7
                       DEC     $4E
                       BNE     L99F5
                       BEQ     L9A05
L99FE:                 JSR     S9B30
                       INC     $4E
                       BNE     L99FE
L9A05:                 JSR     S9F2F
L9A08:                 SEC
                       LDA     #$FF
                       RTS
L9A0C:                 LDA     $49
                       STA     $44
                       AND     #$80
                       ORA     $48
                       BNE     L99E2
                       LDA     $4C
                       STA     $41
                       LDA     $4B
                       STA     $42
                       LDA     $4A
                       STA     $43
                       LDA     #$40
                       SEC
                       RTS
L9A26:                 JSR     S9A38
                       EOR     #$FF
                       SEC
                       RTS
S9A2D:                 INY
                       LDA     (txtptr),Y
                       CMP     #$2D
                       BEQ     L9A26
                       CMP     #$2B
                       BNE     L9A39
S9A38:                 INY
L9A39:                 JSR     S9962
                       BCC     L9A57
                       STA     $61
                       INY
                       JSR     S9962
                       BCC     L9A53
                       INY
                       STA     $5C
                       LDA     $61
                       ASL     
                       ASL     
                       ADC     $61
                       ASL     
                       ADC     $5C
                       RTS
L9A53:                 LDA     $61
                       CLC
                       RTS
L9A57:                 LDA     #$00
                       CLC
                       RTS
S9A5B:                 LDA     $4C
                       ADC     $5B
                       STA     $4C
                       LDA     $4B
                       ADC     $5A
                       STA     $4B
                       LDA     $4A
                       ADC     $59
                       STA     $4A
                       LDA     $49
                       ADC     $58
                       STA     $49
                       LDA     $48
                       ADC     $57
                       STA     $48
                       RTS
L9A7A:                 PHA
                       LDX     $4B
                       LDA     $48
                       PHA
                       LDA     $49
                       PHA
                       LDA     $4A
                       PHA
                       LDA     $4C
                       ASL     
                       ROL     $4B
                       ROL     $4A
                       ROL     $49
                       ROL     $48
                       ASL     
                       ROL     $4B
                       ROL     $4A
                       ROL     $49
                       ROL     $48
                       ADC     $4C
                       STA     $4C
                       TXA
                       ADC     $4B
                       STA     $4B
                       PLA
                       ADC     $4A
                       STA     $4A
                       PLA
                       ADC     $49
                       STA     $49
                       PLA
                       ADC     $48
                       ASL     $4C
                       ROL     $4B
                       ROL     $4A
                       ROL     $49
                       ROL     
                       STA     $48
                       PLA
                       RTS
S9ABD:                 LDA     $48
                       ORA     $49
                       ORA     $4A
                       ORA     $4B
                       ORA     $4C
                       BEQ     L9AD0
                       LDA     $45
                       BNE     L9AD6
                       LDA     #$01
                       RTS
L9AD0:                 STA     $45
                       STA     $47
                       STA     $46
L9AD6:                 RTS
S9AD7:                 CLC
                       LDA     $47
                       ADC     #$03
                       STA     $47
                       BCC     L9AE2
                       INC     $46
L9AE2:                 JSR     S9B01
                       JSR     S9B25
                       JSR     S9B25
S9AEB:                 JSR     S9A5B
L9AEE:                 BCC     L9B00
                       ROR     $48
                       ROR     $49
                       ROR     $4A
                       ROR     $4B
                       ROR     $4C
                       INC     $47
                       BNE     L9B00
                       INC     $46
L9B00:                 RTS
S9B01:                 LDA     $45
                       STA     $54
                       LDA     $46
                       STA     $55
                       LDA     $47
                       STA     $56
                       LDA     $48
                       STA     $57
                       LDA     $49
                       STA     $58
                       LDA     $4A
                       STA     $59
                       LDA     $4B
                       STA     $5A
                       LDA     $4C
                       STA     $5B
                       RTS
S9B22:                 JSR     S9B01
S9B25:                 LSR     $57
                       ROR     $58
                       ROR     $59
                       ROR     $5A
                       ROR     $5B
                       RTS
S9B30:                 SEC
                       LDA     $47
                       SBC     #$04
                       STA     $47
                       BCS     L9B3B
                       DEC     $46
L9B3B:                 JSR     S9B22
                       JSR     S9AEB
                       JSR     S9B22
                       JSR     S9B25
                       JSR     S9B25
                       JSR     S9B25
                       JSR     S9AEB
                       LDA     #$00
                       STA     $57
                       LDA     $48
                       STA     $58
                       LDA     $49
                       STA     $59
                       LDA     $4A
                       STA     $5A
                       LDA     $4B
                       STA     $5B
                       LDA     $4C
                       ROL     
                       JSR     S9AEB
                       LDA     #$00
                       STA     $57
                       STA     $58
                       LDA     $48
                       STA     $59
                       LDA     $49
                       STA     $5A
                       LDA     $4A
                       STA     $5B
                       LDA     $4B
                       ROL     
                       JSR     S9AEB
                       LDA     $49
                       ROL     
                       LDA     $48
S9B87:                 ADC     $4C
                       STA     $4C
                       BCC     L9BA0
                       INC     $4B
                       BNE     L9BA0
                       INC     $4A
                       BNE     L9BA0
                       INC     $49
                       BNE     L9BA0
                       INC     $48
                       BNE     L9BA0
                       JMP     L9AEE
L9BA0:                 RTS
FINT:                  JSR     SA3A3
S9BA4:                 LDX     #$00
                       STX     $4C
                       STX     $46
                       LDA     $44
                       BPL     L9BB3
                       JSR     SA3D6
                       LDX     #$FF
L9BB3:                 STX     $45
                       LDA     $41
                       STA     $4B
                       LDA     $42
                       STA     $4A
                       LDA     $43
                       STA     $49
                       LDA     $44
                       STA     $48
                       LDA     #$A0
                       STA     $47
                       BNE     L9BE8
L9BCB:                 STA     $45
                       STA     $47
                       STA     $46
L9BD1:                 RTS
S9BD2:                 PHA
                       JSR     S9F54
                       PLA
                       BEQ     L9BD1
                       BPL     L9BE2
                       STA     $45
                       LDA     #$00
                       SEC
                       SBC     $45
L9BE2:                 STA     $48
                       LDA     #$88
                       STA     $47
L9BE8:                 LDA     $48
                       BMI     L9BD1
                       ORA     $49
                       ORA     $4A
                       ORA     $4B
                       ORA     $4C
                       BEQ     L9BCB
                       LDA     $47
L9BF8:                 LDY     $48
                       BMI     L9BD1
                       BNE     L9C1F
                       LDX     $49
                       STX     $48
                       LDX     $4A
                       STX     $49
                       LDX     $4B
                       STX     $4A
                       LDX     $4C
                       STX     $4B
                       STY     $4C
                       SEC
                       SBC     #$08
                       STA     $47
                       BCS     L9BF8
                       DEC     $46
                       BCC     L9BF8
L9C1B:                 LDY     $48
                       BMI     L9BD1
L9C1F:                 ASL     $4C
                       ROL     $4B
                       ROL     $4A
                       ROL     $49
                       ROL     $48
                       SBC     #$00
                       STA     $47
                       BCS     L9C1B
                       DEC     $46
                       BCC     L9C1B
S9C33:                 LDY     #$04
                       LDA     ($62),Y
                       STA     $5A
                       DEY
                       LDA     ($62),Y
                       STA     $59
                       DEY
                       LDA     ($62),Y
                       STA     $58
                       DEY
                       LDA     ($62),Y
                       STA     $54
                       DEY
                       STY     $5B
                       STY     $55
                       LDA     ($62),Y
                       STA     $56
                       ORA     $54
                       ORA     $58
                       ORA     $59
                       ORA     $5A
                       BEQ     L9C5F
                       LDA     $54
                       ORA     #$80
L9C5F:                 STA     $57
                       RTS
S9C62:                 LDA     #$71
                       DFB     $2C          ; BIT - Skips the next instruction.
S9C65:                 LDA     #$76
                       DFB     $2C          ; BIT - skips the next instruction.
S9C68:                 LDA     #$6C
S9C6A:                 STA     $62
                       LDA     #$04
                       STA     $63
S9C70:                 LDY     #$00
                       LDA     $47
                       STA     ($62),Y
                       INY
                       LDA     $45
                       AND     #$80
                       STA     $45
                       LDA     $48
                       AND     #$7F
                       ORA     $45
                       STA     ($62),Y
                       LDA     $49
                       INY
                       STA     ($62),Y
                       LDA     $4A
                       INY
                       STA     ($62),Y
                       LDA     $4B
                       INY
                       STA     ($62),Y
                       RTS
L9C95:                 JSR     SA0B1
S9C98:                 LDY     #$04
                       LDA     ($62),Y
                       STA     $4B
                       DEY
                       LDA     ($62),Y
                       STA     $4A
                       DEY
                       LDA     ($62),Y
                       STA     $49
                       DEY
                       LDA     ($62),Y
                       STA     $45
                       DEY
                       LDA     ($62),Y
                       STA     $47
                       STY     $4C
                       STY     $46
                       ORA     $45
                       ORA     $49
                       ORA     $4A
                       ORA     $4B
                       BEQ     L9CC4
                       LDA     $45
                       ORA     #$80
L9CC4:                 STA     $48
                       RTS
L9CC7:                 JSR     S9CE3
L9CCA:                 LDA     $48
                       STA     $44
                       LDA     $49
                       STA     $43
                       LDA     $4A
                       STA     $42
                       LDA     $4B
                       STA     $41
                       JMP     LB932
L9CDD:                 JSR     S9B01
                       JMP     S9F54
S9CE3:                 LDA     $47
                       BPL     L9CDD
                       JSR     S9F51
                       JSR     S9ABD
                       BNE     L9D21
                       BEQ     L9D39
L9CF1:                 LDA     $47
                       CMP     #$A0
                       BCS     L9D37
                       CMP     #$99
                       BCS     L9D21
                       ADC     #$08
                       STA     $47
                       LDA     $59
                       STA     $5A
                       LDA     $58
                       STA     $59
                       LDA     $57
                       STA     $58
                       LDA     $4B
                       STA     $57
                       LDA     $4A
                       STA     $4B
                       LDA     $49
                       STA     $4A
                       LDA     $48
                       STA     $49
                       LDA     #$00
                       STA     $48
                       BEQ     L9CF1
L9D21:                 LSR     $48
                       ROR     $49
                       ROR     $4A
                       ROR     $4B
                       ROR     $57
                       ROR     $58
                       ROR     $59
                       ROR     $5A
                       INC     $47
                       BNE     L9CF1
L9D35:                 BRK
L9D36:                 DFB     $21                                    ; !
L9D37:                 BNE     L9D35
L9D39:                 LDA     $45
                       BPL     L9D56
S9D3D:                 SEC
                       LDA     #$00
                       SBC     $4B
                       STA     $4B
                       LDA     #$00
                       SBC     $4A
                       STA     $4A
                       LDA     #$00
                       SBC     $49
                       STA     $49
                       LDA     #$00
                       SBC     $48
                       STA     $48
L9D56:                 RTS
S9D57:                 LDA     $47
                       BMI     L9D62
                       LDA     #$00
                       STA     $61
                       JMP     S9ABD
L9D62:                 JSR     S9CE3
                       LDA     $4B
                       STA     $61
                       JSR     S9DAA
                       LDA     #$80
                       STA     $47
                       LDX     $48
                       BPL     L9D84
                       EOR     $45
                       STA     $45
                       BPL     L9D7F
                       INC     $61
                       JMP     L9D81
L9D7F:                 DEC     $61
L9D81:                 JSR     S9D3D
L9D84:                 JMP     L9BE8
S9D87:                 INC     $4B
                       BNE     L9D97
                       INC     $4A
                       BNE     L9D97
                       INC     $49
                       BNE     L9D97
                       INC     $48
                       BEQ     L9D35
L9D97:                 RTS
S9D98:                 JSR     S9C33
                       JSR     S9C70
L9D9E:                 LDA     $54
                       STA     $45
                       LDA     $55
                       STA     $46
                       LDA     $56
                       STA     $47
S9DAA:                 LDA     $57
                       STA     $48
                       LDA     $58
                       STA     $49
                       LDA     $59
                       STA     $4A
                       LDA     $5A
                       STA     $4B
                       LDA     $5B
                       STA     $4C
L9DBE:                 RTS
S9DBF:                 JSR     LA3C2
S9DC2:                 JSR     S9C33
                       BEQ     L9DBE
S9DC7:                 JSR     S9DCD
                       JMP     S9F2F
S9DCD:                 JSR     S9ABD
                       BEQ     L9D9E
                       LDY     #$00
                       SEC
                       LDA     $47
                       SBC     $56
                       BEQ     L9E52
                       BCC     L9E14
                       CMP     #$25
                       BCS     L9DBE
                       PHA
                       AND     #$38
                       BEQ     L9DFF
                       LSR     
                       LSR     
                       LSR     
                       TAX
L9DEA:                 LDA     $5A
                       STA     $5B
                       LDA     $59
                       STA     $5A
                       LDA     $58
                       STA     $59
                       LDA     $57
                       STA     $58
                       STY     $57
                       DEX
                       BNE     L9DEA
L9DFF:                 PLA
                       AND     #$07
                       BEQ     L9E52
                       TAX
L9E05:                 LSR     $57
                       ROR     $58
                       ROR     $59
                       ROR     $5A
                       ROR     $5B
                       DEX
                       BNE     L9E05
                       BEQ     L9E52
L9E14:                 SEC
                       LDA     $56
                       SBC     $47
                       CMP     #$25
                       BCS     L9D9E
                       PHA
                       AND     #$38
                       BEQ     L9E3B
                       LSR     
                       LSR     
                       LSR     
                       TAX
L9E26:                 LDA     $4B
                       STA     $4C
                       LDA     $4A
                       STA     $4B
                       LDA     $49
                       STA     $4A
                       LDA     $48
                       STA     $49
                       STY     $48
                       DEX
                       BNE     L9E26
L9E3B:                 PLA
                       AND     #$07
                       BEQ     L9E4E
                       TAX
L9E41:                 LSR     $48
                       ROR     $49
                       ROR     $4A
                       ROR     $4B
                       ROR     $4C
                       DEX
                       BNE     L9E41
L9E4E:                 LDA     $56
                       STA     $47
L9E52:                 LDA     $45
                       EOR     $54
                       BPL     L9EA1
                       LDA     $48
                       CMP     $57
                       BNE     L9E79
                       LDA     $49
                       CMP     $58
                       BNE     L9E79
                       LDA     $4A
                       CMP     $59
                       BNE     L9E79
                       LDA     $4B
                       CMP     $5A
                       BNE     L9E79
                       LDA     $4C
                       CMP     $5B
                       BNE     L9E79
                       JMP     S9F54
L9E79:                 BCS     L9EA5
                       SEC
                       LDA     $5B
                       SBC     $4C
                       STA     $4C
                       LDA     $5A
                       SBC     $4B
                       STA     $4B
                       LDA     $59
                       SBC     $4A
                       STA     $4A
                       LDA     $58
                       SBC     $49
                       STA     $49
                       LDA     $57
                       SBC     $48
                       STA     $48
                       LDA     $54
                       STA     $45
                       JMP     L9BE8
L9EA1:                 CLC
                       JMP     S9AEB
L9EA5:                 SEC
                       LDA     $4C
                       SBC     $5B
                       STA     $4C
                       LDA     $4B
                       SBC     $5A
                       STA     $4B
                       LDA     $4A
                       SBC     $59
                       STA     $4A
                       LDA     $49
                       SBC     $58
                       STA     $49
                       LDA     $48
                       SBC     $57
                       STA     $48
                       JMP     L9BE8
L9EC7:                 RTS
S9EC8:                 JSR     S9ABD
                       BEQ     L9EC7
                       JSR     S9C33
                       BNE     L9ED5
                       JMP     S9F54
L9ED5:                 CLC
                       LDA     $47
                       ADC     $56
                       BCC     L9EDF
                       INC     $46
                       CLC
L9EDF:                 SBC     #$7F
                       STA     $47
                       BCS     L9EE7
                       DEC     $46
L9EE7:                 LDX     #$05
                       LDY     #$00
L9EEB:                 LDA     $47,X
                       STA     $5B,X
                       STY     $47,X
                       DEX
                       BNE     L9EEB
                       LDA     $45
                       EOR     $54
                       STA     $45
                       LDY     #$20
L9EFC:                 LSR     $57
                       ROR     $58
                       ROR     $59
                       ROR     $5A
                       ROR     $5B
                       ASL     $5F
                       ROL     $5E
                       ROL     $5D
                       ROL     $5C
                       BCC     L9F14
                       CLC
                       JSR     S9A5B
L9F14:                 DEY
                       BNE     L9EFC
                       RTS
FDEG:                  LDY     #$EC
                       LDA     #$A2
                       BNE     L9F25
FLOG:                  JSR     FLN
                       LDY     #$13
                       LDA     #$A1
L9F25:                 STY     $62
                       STA     $63
S9F29:                 JSR     S9EC8
L9F2C:                 JSR     L9BE8
S9F2F:                 LDA     $4C
                       CMP     #$80
                       BCC     L9F45
                       BEQ     L9F3F
                       LDA     #$FF
                       JSR     S9B87
                       JMP     L9F45
L9F3F:                 LDA     $4B
                       ORA     #$01
                       STA     $4B
L9F45:                 LDA     #$00
                       STA     $4C
                       LDA     $46
                       BEQ     L9F60
                       BMI     S9F54
                       BRK
L9F50:                 DFB     $21                                    ; !
S9F51:                 LDX     #$54
                       DFB     $2C          ; BIT - skips the next instruction.
S9F54:                 LDX     #$45
                       LDY     #$08
                       LDA     #$00
L9F5A:                 STA     $00,X
                       INX
                       DEY
                       BNE     L9F5A
L9F60:                 LDA     #$FF
                       RTS
S9F63:                 JSR     S9F54
                       LDY     #$80
                       STY     $48
                       INY
                       STY     $47
                       LDA     #$FF
                       RTS
S9F70:                 JSR     S9C68
                       JSR     S9F63
                       BNE     S9F8E
S9F78:                 JSR     S9ABD
                       BEQ     L9F86
                       JSR     S9B01
                       JSR     S9C98
                       BNE     L9F98
                       RTS
L9F86:                 BRK
L9F87:                 DFB     $21                                    ; !
FRAD:                  JSR     FDEG
                       JSR     S9F8E
S9F8E:                 JSR     S9ABD
                       BEQ     L9F60
                       JSR     S9C33
                       BEQ     L9F86
L9F98:                 LDA     $45
                       EOR     $54
                       STA     $45
                       SEC
                       LDA     $47
                       SBC     $56
                       BCS     L9FA8
                       DEC     $46
                       SEC
L9FA8:                 ADC     #$80
                       STA     $47
                       BCC     L9FB1
                       INC     $46
                       CLC
L9FB1:                 LDX     #$20
L9FB3:                 BCS     L9FCD
                       LDA     $48
                       CMP     $57
                       BNE     L9FCB
                       LDA     $49
                       CMP     $58
                       BNE     L9FCB
                       LDA     $4A
                       CMP     $59
                       BNE     L9FCB
                       LDA     $4B
                       CMP     $5A
L9FCB:                 BCC     L9FE6
L9FCD:                 LDA     $4B
                       SBC     $5A
                       STA     $4B
                       LDA     $4A
                       SBC     $59
                       STA     $4A
                       LDA     $49
                       SBC     $58
                       STA     $49
                       LDA     $48
                       SBC     $57
                       STA     $48
                       SEC
L9FE6:                 ROL     $5F
                       ROL     $5E
                       ROL     $5D
                       ROL     $5C
                       ASL     $4B
                       ROL     $4A
                       ROL     $49
                       ROL     $48
                       DEX
                       BNE     L9FB3
                       LDX     #$07
L9FFB:                 BCS     LA015
                       LDA     $48
                       CMP     $57
                       BNE     LA013
                       LDA     $49
                       CMP     $58
                       BNE     LA013
                       LDA     $4A
                       CMP     $59
                       BNE     LA013
                       LDA     $4B
                       CMP     $5A
LA013:                 BCC     LA02E
LA015:                 LDA     $4B
                       SBC     $5A
                       STA     $4B
                       LDA     $4A
                       SBC     $59
                       STA     $4A
                       LDA     $49
                       SBC     $58
                       STA     $49
                       LDA     $48
                       SBC     $57
                       STA     $48
                       SEC
LA02E:                 ROL     $4C
                       ASL     $4B
                       ROL     $4A
                       ROL     $49
                       ROL     $48
                       DEX
                       BNE     L9FFB
                       ASL     $4C
                       LDA     $5F
                       STA     $4B
                       LDA     $5E
                       STA     $4A
                       LDA     $5D
                       STA     $49
                       LDA     $5C
                       STA     $48
                       JMP     L9F2C
LA050:                 BRK
LA051:                 DFB     $21                                    ; !
FTAN:                  JSR     SA26B
                       LDA     $61
                       PHA
                       JSR     SA0A7
                       JSR     S9C70
                       INC     $61
                       JSR     SA233
                       JSR     SA0A7
                       JSR     S9D98
                       PLA
                       STA     $61
                       JSR     SA233
                       JSR     SA0A7
                       JMP     S9F8E
FSQR:                  JSR     S9ABD
                       BEQ     LA0A4
                       BMI     LA050
                       JSR     S9C68
                       LDA     $47
                       LSR     
                       ADC     #$40
                       STA     $47
                       LDA     #$05
                       STA     $61
                       JSR     SA0AB
LA08D:                 JSR     S9C70
                       LDA     #$6C
                       STA     $62
                       JSR     S9F78
                       LDA     #$71
                       STA     $62
                       JSR     S9DC2
                       DEC     $47
                       DEC     $61
                       BNE     LA08D
LA0A4:                 LDA     #$FF
                       RTS
SA0A7:                 LDA     #$7B
                       BNE     LA0B3
SA0AB:                 LDA     #$71
                       DFB     $2C          ; BIT - skips the next instruction.
SA0AE:                 LDA     #$76
                       DFB     $2C          ; BIT - skips the next instruction.
SA0B1:                 LDA     #$6C
LA0B3:                 STA     $62
                       LDA     #$04
                       STA     $63
                       RTS
FLN:                   JSR     S9ABD
                       BEQ     LA050
                       BMI     LA050
                       JSR     S9F51
                       LDY     #$80
                       STY     $54
                       STY     $57
                       INY
                       STY     $56
                       LDX     $47
                       BEQ     LA0D7
                       LDA     $48
                       CMP     #$B5
                       BCC     LA0D9
LA0D7:                 INX
                       DEY
LA0D9:                 TXA
                       PHA
                       STY     $47
                       JSR     S9DC7
                       LDA     #$7B
                       JSR     S9C6A
                       LDA     #$1D
                       LDY     #$A1
                       JSR     SA141
                       JSR     SA0A7
                       JSR     S9F29
                       JSR     S9F29
                       JSR     S9DC2
                       JSR     S9C68
                       PLA
                       SEC
                       SBC     #$81
                       JSR     S9BD2
                       LDA     #$18
                       STA     $62
                       LDA     #$A1
                       STA     $63
                       JSR     S9F29
                       JSR     SA0B1
                       JMP     S9DC2
LA113:                 DFB     $7F, $5E, $5B, $D8, $AA, $80, $31, $72 ; .^[...1r
                       DFB     $17, $F8, $06, $7A, $12, $38, $A5, $0B ; ...z.8..
                       DFB     $88, $79, $0E, $9F, $F3, $7C, $2A, $AC ; .y...|*.
                       DFB     $3F, $B5, $86, $34, $01, $A2, $7A, $7F ; ?..4..z.
                       DFB     $63, $8E, $37, $EC, $82, $3F, $FF, $FF ; c.7..?..
                       DFB     $C1, $7F, $FF, $FF, $FF, $FF           ; ......
SA141:                 STA     $64
                       STY     $65
                       JSR     S9C68
                       LDY     #$00
                       LDA     ($64),Y
                       STA     $4D
                       INC     $64
                       BNE     LA154
                       INC     $65
LA154:                 LDA     $64
                       STA     $62
                       LDA     $65
                       STA     $63
                       JSR     S9C98
LA15F:                 JSR     SA0B1
                       JSR     S9F78
                       CLC
                       LDA     $64
                       ADC     #$05
                       STA     $64
                       STA     $62
                       LDA     $65
                       ADC     #$00
                       STA     $65
                       STA     $63
                       JSR     S9DC2
                       DEC     $4D
                       BNE     LA15F
                       RTS
FACS:                  JSR     FASN
                       JMP     LA1C5
FASN:                  JSR     S9ABD
                       BPL     LA197
                       LSR     $45
                       JSR     LA197
                       JMP     LA1B4
LA191:                 JSR     SA2DB
                       JMP     S9C98
LA197:                 JSR     S9C65
                       JSR     SA246
                       JSR     S9ABD
                       BEQ     LA191
                       JSR     SA0AE
                       JSR     S9F78
FATN:                  JSR     S9ABD
                       BEQ     LA1B8
                       BPL     LA1B9
                       LSR     $45
                       JSR     LA1B9
LA1B4:                 LDA     #$80
                       STA     $45
LA1B8:                 RTS
LA1B9:                 LDA     $47
                       CMP     #$81
                       BCC     LA1D4
                       JSR     S9F70
                       JSR     LA1D4
LA1C5:                 JSR     SA2E3
                       JSR     S9DC2
                       JSR     SA2DF
                       JSR     S9DC2
                       JMP     LA3C2
LA1D4:                 LDA     $47
                       CMP     #$73
                       BCC     LA1B8
                       JSR     S9C65
                       JSR     S9F51
                       LDA     #$80
                       STA     $56
                       STA     $57
                       STA     $54
                       JSR     S9DC7
                       LDA     #$F5
                       LDY     #$A1
                       JSR     SA141
                       JMP     LA344
LA1F5:                 DFB     $09, $85, $A3, $59, $E8, $67, $80, $1C ; ...Y.g..
                       DFB     $9D, $07, $36, $80, $57, $BB, $78, $DF ; ..6.W.x.
                       DFB     $80, $CA, $9A, $0E, $83, $84, $8C, $BB ; ........
                       DFB     $CA, $6E, $81, $95, $96, $06, $DE, $81 ; .n......
                       DFB     $0A, $C7, $6C, $52, $7F, $7D, $AD, $90 ; ..lR.}..
                       DFB     $A1, $82, $FB, $62, $57, $2F, $80, $6D ; ...bW/.m
                       DFB     $63, $38, $2C                          ; c8,
FCOS:                  JSR     SA26B
                       INC     $61
                       JMP     SA233
FSIN:                  JSR     SA26B
SA233:                 LDA     $61
                       AND     #$02
                       BEQ     LA23F
                       JSR     LA23F
                       JMP     LA3C2
LA23F:                 LSR     $61
                       BCC     LA25B
                       JSR     LA25B
SA246:                 JSR     S9C68
                       JSR     S9F29
                       JSR     S9C70
                       JSR     S9F63
                       JSR     S9DBF
                       JSR     LA3C2
                       JMP     FSQR
LA25B:                 JSR     S9C65
                       JSR     S9F29
                       LDA     #$F1
                       LDY     #$A2
                       JSR     SA141
                       JMP     LA344
SA26B:                 LDA     $47
                       CMP     #$98
                       BCS     LA2CA
                       JSR     S9C68
                       JSR     SA2DB
                       JSR     S9C33
                       LDA     $45
                       STA     $54
                       DEC     $56
                       JSR     S9DC7
                       JSR     S9F8E
                       JSR     S9CE3
                       LDA     $4B
                       STA     $61
                       ORA     $4A
                       ORA     $49
                       ORA     $48
                       BEQ     LA2C7
                       LDA     #$A0
                       STA     $47
                       LDY     #$00
                       STY     $4C
                       LDA     $48
                       STA     $45
                       BPL     LA2A6
                       JSR     S9D3D
LA2A6:                 JSR     L9BE8
                       JSR     S9C62
                       JSR     SA2E3
                       JSR     SA2BE
                       JSR     S9C70
                       JSR     SA0AB
                       JSR     S9C98
                       JSR     SA2DF
SA2BE:                 JSR     S9F29
                       JSR     SA0B1
                       JMP     S9DC2
LA2C7:                 JMP     L9C95
LA2CA:                 BRK
                       TRB     $C981
                       BPL     $A2D0
                       BRK
LA2D1:                 DFB     $6F, $15, $77, $7A, $61, $81, $49, $0F ; o.wza.I.
                       DFB     $DA, $A2                               ; ..
SA2DB:                 LDA     #$D6
                       BNE     LA2E5
SA2DF:                 LDA     #$D1
                       BNE     LA2E5
SA2E3:                 LDA     #$CC
LA2E5:                 STA     $62
                       LDA     #$A2
                       STA     $63
                       RTS
LA2EC:                 DFB     $86, $65, $2E, $E0, $D3, $05, $84, $8A ; .e......
                       DFB     $EA, $0C, $1B, $84, $1A, $BE, $BB, $2B ; .......+
                       DFB     $84, $37, $45, $55, $AB, $82, $D5, $55 ; .7EU...U
                       DFB     $57, $7C, $83, $C0, $00, $00, $05, $81 ; W|......
                       DFB     $00, $00, $00, $00                     ; ....
FEXP:                  LDA     $47
                       CMP     #$87
                       BCC     LA327
                       BNE     LA31E
                       LDY     $48
                       CPY     #$B3
                       BCC     LA327
LA31E:                 LDA     $45
                       BPL     LA325
                       JMP     S9F54
LA325:                 BRK
LA326:                 DFB     $21                                    ; !
LA327:                 JSR     S9D57
                       LDA     #$4F
                       LDY     #$A3
                       JSR     SA141
                       JSR     S9C65
                       LDA     #$4A
                       STA     $62
                       LDA     #$A3
                       STA     $63
                       JSR     S9C98
                       LDA     $61
                       JSR     SA378
LA344:                 JSR     SA0AE
                       JMP     S9F29
LA34A:                 DFB     $82, $2D, $F8, $54, $58, $07, $83, $E0 ; .-.TX...
                       DFB     $20, $86, $5B, $82, $80, $53, $93, $B8 ;  .[..S..
                       DFB     $83, $20, $00, $06, $A1, $82, $00, $00 ; . ......
                       DFB     $21, $63, $82, $C0, $00, $00, $02, $82 ; !c......
                       DFB     $80, $00, $00, $0C, $81, $00, $00, $00 ; ........
                       DFB     $00, $81, $00, $00, $00, $00           ; ......
SA378:                 TAX
                       BPL     LA384
                       DEX
                       TXA
                       EOR     #$FF
                       PHA
                       JSR     S9F70
                       PLA
LA384:                 PHA
                       JSR     S9C68
                       JSR     S9F63
LA38B:                 PLA
                       BEQ     LA398
                       SEC
                       SBC     #$01
                       PHA
                       JSR     S9F29
                       JMP     LA38B
LA398:                 JMP     LB5A2
FPI:                   JSR     LA191
                       INC     $47
                       JMP     LB5A2
SA3A3:                 LDA     $45
                       PHP
                       JSR     S9CE3
                       PLP
                       BPL     LA3BF
                       LDA     $57
                       ORA     $58
                       ORA     $59
                       ORA     $5A
                       BEQ     LA3BF
                       JSR     S9D3D
                       JSR     S9D87
                       JSR     S9D3D
LA3BF:                 JMP     L9CCA
LA3C2:                 JSR     S9ABD
                       BEQ     LA3CD
                       LDA     $45
                       EOR     #$80
                       STA     $45
LA3CD:                 RTS
SA3CE:                 BIT     $44
                       BMI     SA3D6
                       RTS
FTRUE:                 JSR     SB86A
SA3D6:                 LDA     #$00
                       TAY
                       SEC
                       SBC     $41
                       STA     $41
                       TYA
                       SBC     $42
                       STA     $42
                       TYA
                       SBC     $43
                       STA     $43
                       TYA
                       SBC     $44
                       STA     $44
                       LDA     #$40
                       RTS
SA3F0:                 LDA     $44
                       BMI     LA428
                       ORA     $43
                       ORA     $42
                       BNE     SA402
                       LDA     $41
                       BEQ     LA448
                       CMP     #$01
                       BEQ     LA445
SA402:                 JSR     S9BA4
                       JSR     SA471
                       JSR     LA445
                       JSR     SA49D
                       JSR     S9EC8
                       JSR     L9BE8
                       JSR     L9CC7
SA417:                 INC     $41
                       BNE     LA425
                       INC     $42
                       BNE     LA425
                       INC     $43
                       BNE     LA425
                       INC     $44
LA425:                 LDA     #$40
                       RTS
LA428:                 LDX     #$2F
                       JSR     SA522
                       STA     $33
                       LDA     #$40
                       RTS
SA432:                 LDA     $03,X
                       STA     $44
                       LDA     $02,X
                       STA     $43
SA43A:                 LDA     $01,X
                       STA     $42
                       LDA     $00,X
                       STA     $41
                       LDA     #$40
                       RTS
LA445:                 JSR     SA459
LA448:                 JSR     S9F63
                       DEC     $47
                       LDX     #$03
LA44F:                 LDA     $2F,X
                       STA     $48,X
                       DEX
                       BPL     LA44F
                       JMP     L9F2C
SA459:                 LDY     #$20
LA45B:                 LDA     $31
                       LSR     
                       LSR     
                       LSR     
                       EOR     $33
                       ROR     
                       ROL     $2F
                       ROL     $30
                       ROL     $31
                       ROL     $32
                       ROL     $33
                       DEY
                       BNE     LA45B
                       RTS
SA471:                 LDA     #$05
                       JSR     SA505
                       LDY     #$00
                       LDA     $47
                       STA     (aestkp),Y
                       INY
                       LDA     $45
                       AND     #$80
                       STA     $45
                       LDA     $48
                       AND     #$7F
                       ORA     $45
                       STA     (aestkp),Y
                       INY
                       LDA     $49
                       STA     (aestkp),Y
                       INY
                       LDA     $4A
                       STA     (aestkp),Y
                       INY
                       LDA     $4B
                       STA     (aestkp),Y
                       LDA     #$FF
                       RTS
SA49D:                 JSR     SA4AC
                       LDA     aestkp
                       CLC
                       ADC     #$05
                       STA     aestkp
                       BCC     LA4AB
                       INC     aestkp+1
LA4AB:                 RTS
SA4AC:                 LDA     aestkp
                       STA     $62
                       LDA     aestkp+1
                       STA     $63
                       RTS
SA4B5:                 JSR     SB2EB
                       INC     txtoff
SA4BA:                 LDA     #$04
                       JSR     SA505
                       LDY     #$03
                       LDA     $44
                       STA     (aestkp),Y
                       DEY
                       LDA     $43
                       STA     (aestkp),Y
                       DEY
SA4CB:                 LDA     $42
                       STA     (aestkp),Y
                       DEY
                       LDA     $41
                       STA     (aestkp),Y
                       RTS
SA4D5:                 LDY     #$03
                       LDA     (aestkp),Y
                       STA     $44
                       DEY
                       LDA     (aestkp),Y
                       STA     $43
                       DEY
                       LDA     (aestkp),Y
                       STA     $42
                       DEY
                       LDA     (aestkp),Y
                       STA     $41
                       JMP     S9738
SA4ED:                 LDY     #$03
                       LDA     (aestkp),Y
                       STA     $03,X
                       DEY
                       LDA     (aestkp),Y
                       STA     $02,X
                       DEY
                       LDA     (aestkp),Y
                       STA     $01,X
                       DEY
                       LDA     (aestkp),Y
                       STA     $00,X
                       JMP     S9738
SA505:                 SEC
                       DFB     $24          ; BIT - skips the next instruction.
SA507:                 CLC
                       STA     $34
                       LDA     aestkp
                       SBC     $34
SA50E:                 STA     aestkp
                       BCS     LA514
                       DEC     aestkp+1
LA514:                 LDY     aestkp+1
SA516:                 CPY     vartop+1
                       BCC     LA520
                       BNE     LA532
                       CMP     vartop
                       BCS     LA532
LA520:                 BRK
LA521:                 DFB     $14                                    ; .
SA522:                 LDA     $44
                       STA     $03,X
                       LDA     $43
                       STA     $02,X
LA52A:                 LDA     $42
                       STA     $01,X
                       LDA     $41
                       STA     $00,X
LA532:                 RTS
PRINT:                 CPX     #$8D
                       BNE     LA53A
                       JMP     WRITE
LA53A:                 LDY     #$02
LA53C:                 LDA     $0400,Y
                       PHA
                       DEY
                       BPL     LA53C
                       DEC     txtoff
LA545:                 LDX     #$00
LA547:                 STX     $70
LA549:                 JSR     SB304
                       CPX     #$3B
                       BEQ     LA547
                       CPX     #$2C
                       BNE     LA56D
                       STX     $70
                       LDA     $0400
                       BEQ     LA549
                       LDA     $0B
LA55D:                 SBC     $0400
                       BEQ     LA549
                       BCS     LA55D
                       EOR     #$FF
                       ADC     #$01
                       JSR     S8347
                       BEQ     LA549
LA56D:                 CPX     #$27
                       BNE     LA576
                       JSR     S835B
                       BCS     LA545
LA576:                 CPX     #$92
                       BNE     LA5A5
                       JSR     SB2E8
                       LDA     $41
                       LDX     $6A
                       CPX     #$29
                       BEQ     LA59C
                       PHA
                       JSR     SB2E8
                       LDA     #$1F
                       JSR     oswrch
                       PLA
                       STA     $0B
                       JSR     oswrch
                       LDA     $41
                       JSR     oswrch
                       JMP     LA545
LA59C:                 SBC     $0B
                       BCC     LA545
                       JSR     S8347
                       BEQ     LA545
LA5A5:                 CPX     #$95
                       BNE     LA5D1
                       JSR     expri
                       LDX     $4F
                       BEQ     LA545
                       LDA     #$02
                       STA     $0402
                       LDX     #$00
                       LDY     $4F
LA5B9:                 LDA     $05FF,Y
                       CMP     #$2E
                       BEQ     LA5C6
                       INX
                       DEY
                       BPL     LA5B9
                       LDX     #$00
LA5C6:                 STX     $0401
                       LDA     $4F
                       STA     $0400
                       JMP     LA545
LA5D1:                 JSR     S89B1
                       BNE     LA5F0
                       LDA     $70
                       CMP     #$2C
                       BEQ     LA5E3
                       CMP     #$3B
                       BEQ     LA5E3
                       JSR     S835B
LA5E3:                 LDX     #$00
LA5E5:                 PLA
                       STA     $0400,X
                       INX
                       CPX     #$03
                       BNE     LA5E5
                       CLC
                       RTS
LA5F0:                 LDA     $70
                       PHA
                       JSR     expr1
                       BEQ     LA61C
                       JSR     S97D0
                       PLA
                       PHA
                       CMP     #$3B
                       BEQ     LA61C
                       LDA     $0400
                       BEQ     LA61C
                       SEC
                       LDA     $0B
LA609:                 BEQ     LA610
                       SBC     $0400
                       BCS     LA609
LA610:                 CLC
                       ADC     $0400
                       SEC
                       SBC     $4F
                       BCC     LA61C
                       JSR     S8347
LA61C:                 PLA
                       STA     $70
                       JSR     L8221
                       DEC     txtoff
                       JMP     LA545
SA627:                 JSR     S8AE5
                       TSX
                       STX     $2D
                       JSR     SAAB9
                       BCC     LA638
                       JSR     SAC0D
                       JSR     SB02C
LA638:                 JSR     LB308
                       LDA     $40
                       STA     $25
                       CMP     #$01
                       BEQ     LA668
                       JSR     SBEF4
                       LDA     $40
                       BEQ     LA66A
                       JSR     SA7EE
                       STA     $40
                       ROR     $7D
                       JSR     LB308
                       ROL     $7D
                       BCC     LA689
                       DFB     $2C          ; BIT - skip the next instruction.
LA659:                 STX     $4F
LA65B:                 JSR     SBEF4
                       LDA     $25
                       JSR     SAF0F
                       CLC
                       BCC     LA68D
                       CLC
                       RTS
LA668:                 BRK
LA669:                 DFB     $1B                                    ; .
LA66A:                 TAX
                       LDY     txtoff
                       LDA     (txtptr),Y
                       CMP     #$22
                       BEQ     LA684
LA673:                 LDY     txtoff
                       LDA     (txtptr),Y
                       JSR     S8AB9
                       BEQ     LA659
                       STA     $0600,X
                       INX
                       INC     txtoff
                       BNE     LA673
LA684:                 JSR     SB7A2
                       BCC     LA65B
LA689:                 JSR     SBEF4
                       SEC
LA68D:                 PLA
                       PLA
                       PLA
                       LDA     #$00
                       STA     $2D
                       RTS
LA695:                 PLA
                       STA     txtoff
                       LDA     #$21
                       STA     erflag
                       SEC
                       ROR     $3E
                       JSR     S810E
                       ASL     $3E
                       JSR     LB308
INPUT:                 LDA     #$19
                       STA     $18
                       CPX     #$8D
                       BEQ     LA6FE
                       LDA     txtoff
                       PHA
                       CPX     #$22
                       BEQ     LA6BD
LA6B6:                 LDA     #$3F
                       JSR     outchr
                       BCS     LA6C6
LA6BD:                 JSR     SB7A2
                       JSR     L8221
                       JSR     S8B11
LA6C6:                 LDA     #$00
                       LDY     #$06
                       STA     $19
                       STY     $1A
                       STA     $1B
                       JSR     S83D5
LA6D3:                 JSR     SA627
                       BCS     LA695
                       JSR     S8B11
                       PLA
                       CPX     #$2C
                       BNE     LA736
                       PHA
                       JSR     SBEF4
                       JSR     S8B11
                       CPX     #$2C
                       PHP
                       JSR     SBEF4
                       PLP
                       BEQ     LA6D3
                       LDA     #$3F
                       JSR     outchr
                       JMP     LA6B6
LA6F8:                 BRK
LA6F9:                 DFB     $21                                    ; !
LA6FA:                 BRK
LA6FB:                 DFB     $22                                    ; "
READ:                  CPX     #$8D
LA6FE:                 BEQ     LA75E
                       LDA     $2E
                       BMI     LA6FA
                       LDX     #$7A
                       STX     $18
                       JSR     SA627
                       BCS     LA6F8
                       JSR     SBEF4
                       JSR     S8B11
                       CPX     #$2C
                       BEQ     LA72C
                       JSR     S8AA9
                       JSR     S8A14
                       JSR     S8A72
                       LDA     #$00
                       SBC     #$00
                       STA     $2E
                       INY
                       STY     txtoff
                       JSR     S8AA0
LA72C:                 JSR     SBEF4
                       JSR     S8B11
                       CPX     #$2C
                       BEQ     READ
LA736:                 CLC
                       RTS
RESTOR:                JSR     S89B1
                       BEQ     LA743
                       JSR     S8FE9
                       JMP     LA746
LA743:                 JSR     S8F43
LA746:                 JSR     S8A72
                       BCC     LA758
                       INY
                       STY     $7C
                       LDA     $26
                       STA     $7A
                       LDA     $27
                       STA     $7B
                       LDA     #$00
LA758:                 SBC     #$00
                       STA     $2E
                       CLC
                       RTS
LA75E:                 JSR     SA963
LA761:                 LDX     $71
                       LDA     $04B7,X
                       CMP     #$DD
                       BEQ     LA76E
                       CMP     #$8B
                       BNE     LA770
LA76E:                 BRK
LA76F:                 DFB     $1B                                    ; .
LA770:                 JSR     SAAB9
                       BCC     LA77B
                       JSR     SAC0D
                       JSR     SB02C
LA77B:                 JSR     SA7E3
                       STA     $29
                       EOR     $40
                       AND     #$40
                       BEQ     LA793
                       LDA     #$00
                       JSR     SA9D0
                       JSR     SB99D
                       JSR     SA9CE
                       BRK
LA792:                 DFB     $17                                    ; .
LA793:                 LDX     #$04
                       LDA     $29
                       BNE     LA7AC
                       JSR     SA7E3
                       STA     $4F
                       TAX
                       BEQ     LA7BC
LA7A1:                 JSR     SA7E3
                       STA     $05FF,X
                       DEX
                       BNE     LA7A1
                       BEQ     LA7BC
LA7AC:                 BMI     LA7CC
LA7AE:                 JSR     SA7E3
                       STA     $40,X
                       DEX
                       BNE     LA7AE
                       LDA     #$40
LA7B8:                 LDX     $40
                       STA     $40
LA7BC:                 JSR     SAF0F
                       JSR     S89B1
                       BEQ     LA7C9
                       INC     txtoff
                       JMP     LA761
LA7C9:                 JMP     LA93C
LA7CC:                 INX
LA7CD:                 JSR     SA7E3
                       STA     $046B,X
                       DEX
                       BNE     LA7CD
                       JSR     S8AC0
                       JSR     L9C95
                       JSR     S8AD6
                       LDA     #$FF
                       BMI     LA7B8
SA7E3:                 LDY     $75
                       JSR     $FFD7
                       BCC     LA809
                       BRK
LA7EB:                 DFB     $2A                                    ; *
LA7EC:                 INC     txtoff
SA7EE:                 JSR     LB308
                       CPX     #$2B
                       BEQ     LA7EC
                       CPX     #$2D
                       BEQ     LA7FC
                       JMP     S996D
LA7FC:                 JSR     LA7EC
                       BCC     LA809
                       BPL     LA80A
                       JSR     LA3C2
                       SEC
                       LDA     #$FF
LA809:                 RTS
LA80A:                 JSR     SA3D6
                       SEC
                       LDA     #$40
                       RTS
OPEN:                  JSR     SAA01
                       BEQ     LA818
                       BRK
LA817:                 DFB     $27                                    ; '
LA818:                 STX     $71
                       JSR     expri
                       JSR     S86F5
                       JSR     FFALSE
                       JSR     SB304
                       TXA
                       LDX     $71
                       STA     $04B7,X
                       CMP     #$8F
                       BNE     LA833
                       JSR     SB2E8
LA833:                 LDX     $71
                       LDA     $41
                       STA     $04B8,X
                       LDA     $42
                       STA     $04B9,X
                       JSR     LB308
                       TXA
                       CMP     #$FC
                       BNE     LA84C
                       LDX     $71
                       STA     $04B7,X
LA84C:                 LDX     $71
                       LDY     $04B7,X
                       LDA     #$40
                       CPY     #$DA
                       BNE     LA859
                       LDA     #$80
LA859:                 CPY     #$8F
                       BNE     LA85F
                       LDA     #$C0
LA85F:                 CPY     #$8B
                       BEQ     LA874
SA863:                 LDX     #$00
                       LDY     #$06
                       JSR     $FFCE
                       TAY
                       BEQ     LA897
                       LDX     $71
                       STA     $04B6,X
                       CLC
                       RTS
LA874:                 LDA     #$C0
                       JSR     SA863
                       LDX     #$50
                       LDA     #$02
                       JSR     $FFDA
                       LDA     #$01
                       JSR     $FFDA
                       LDX     $71
                       LDY     #$00
LA889:                 LDA     $0050,Y
                       STA     $04BA,X
                       INX
                       INY
                       CPY     #$04
                       BNE     LA889
                       CLC
                       RTS
LA897:                 LDX     $71
                       LDA     $04B7,X
                       CMP     #$8F
                       BNE     LA8AC
                       LDA     #$80
                       JSR     SA863
                       TAY
                       JSR     SA8BC
                       JMP     LA84C
LA8AC:                 BRK
LA8AD:                 DFB     $20                                    ;  
CLOSE:                 JSR     S89B1
                       BEQ     LA8C3
                       JSR     SAA2F
                       PHA
                       JSR     SA8D0
                       PLA
                       TAY
SA8BC:                 LDA     #$00
                       JSR     $FFCE
                       CLC
                       RTS
LA8C3:                 LDX     #$33
                       LDA     #$00
                       TAY
LA8C8:                 STA     $04B6,X
                       DEX
                       BPL     LA8C8
                       BMI     SA8BC
SA8D0:                 LDY     #$00
                       TYA
LA8D3:                 STA     $04B6,X
                       INX
                       INY
                       CPY     #$08
                       BNE     LA8D3
                       RTS
WRITE:                 JSR     SA963
LA8E0:                 JSR     expr1
                       PHA
                       BEQ     LA95B
                       BMI     LA951
                       LDA     #$41
                       LDX     #$00
                       LDY     #$03
LA8EE:                 STA     $62
                       STX     $63
LA8F2:                 INY
                       STY     $28
                       LDA     $72
                       CMP     #$8F
                       BEQ     LA8FF
                       CMP     #$FC
                       BNE     LA910
LA8FF:                 CLC
                       LDA     $73
                       SBC     $28
                       STA     $73
                       LDA     $74
                       SBC     #$00
                       STA     $74
                       BCS     LA910
                       BRK
LA90F:                 DFB     $23                                    ; #
LA910:                 PLA
                       PHA
                       JSR     SA94A
                       DEC     $28
                       LDY     $28
                       PLA
                       BNE     LA923
                       TYA
                       JSR     SA94A
                       JMP     LA92A
LA923:                 STY     $28
                       LDA     ($62),Y
                       JSR     SA94A
LA92A:                 LDY     $28
                       DEY
                       BPL     LA923
                       JSR     S8B11
                       JSR     S89B4
                       BEQ     LA93C
                       JSR     S89B1
                       BNE     LA8E0
LA93C:                 LDX     $71
                       INC     $04BA,X
                       BNE     LA94F
                       INC     $04BB,X
                       BNE     LA94F
                       BRK
LA949:                 DFB     $21                                    ; !
SA94A:                 LDY     $75
                       JMP     $FFD4
LA94F:                 CLC
                       RTS
LA951:                 JSR     SA471
                       JSR     SA49D
                       LDY     #$04
                       BNE     LA8F2
LA95B:                 LDY     $4F
                       LDA     #$00
                       LDX     #$06
                       BNE     LA8EE
SA963:                 JSR     SAA2F
                       STX     $71
                       STA     $75
                       LDA     $04B7,X
                       STA     $72
                       CMP     #$8F
                       BEQ     LA988
                       CMP     #$FC
                       BEQ     LA988
                       LDA     $6A
                       CMP     #$3A
                       BEQ     LA97F
                       BRK
LA97E:                 DFB     $1B                                    ; .
LA97F:                 LDA     #$00
                       STA     $73
                       STA     $74
                       JMP     SB304
LA988:                 LDA     $6A
                       CMP     #$2C
                       BEQ     LA9A0
                       LDY     #$00
                       LDX     $71
LA992:                 LDA     $04BA,X
                       STA     $0041,Y
                       INX
                       INY
                       CPY     #$04
                       BNE     LA992
                       BEQ     LA9B3
LA9A0:                 JSR     SB2E8
                       LDY     #$00
                       LDX     $71
LA9A7:                 LDA     $0041,Y
                       STA     $04BA,X
                       INX
                       INY
                       CPY     #$04
                       BNE     LA9A7
LA9B3:                 JSR     SA4BA
                       JSR     FFALSE
                       LDX     $71
                       LDA     $04B8,X
                       STA     $41
                       STA     $73
                       LDA     $04B9,X
                       STA     $42
                       STA     $74
                       JSR     S9760
                       INC     txtoff
SA9CE:                 LDA     #$01
SA9D0:                 LDX     #$41
                       LDY     $75
                       JMP     $FFDA
SELECT:                JSR     expr1
                       LDA     $4F
                       BNE     LA9E5
LA9DE:                 LDA     #$03
LA9E0:                 JSR     oswrch
                       CLC
                       RTS
LA9E5:                 LDA     $0600
                       AND     #$DF
                       CMP     #$50
                       BNE     LA9F2
                       LDX     #$01
                       BNE     LA9F8
LA9F2:                 CMP     #$53
                       BNE     LA9DE
                       LDX     #$02
LA9F8:                 LDA     #$05
                       JSR     osbyte
                       LDA     #$02
                       BNE     LA9E0
SAA01:                 JSR     SB2E8
SAA04:                 LDA     $41
                       CMP     #$06
                       BCS     LAA12
                       ASL     
                       ASL     
                       ASL     
                       TAX
                       LDA     $04B6,X
                       RTS
LAA12:                 BRK
LAA13:                 DFB     $21                                    ; !
FEXT:                  JSR     SAA32
                       TAY
                       LDX     #$41
                       LDA     #$02
                       JSR     $FFDA
                       JMP     LB932
FEOF:                  JSR     SAA32
                       TAX
                       LDA     #$7F
                       JSR     osbyte
                       TXA
                       JMP     LB89A
SAA2F:                 JSR     SB2E8
SAA32:                 JSR     SAA04
                       BEQ     LAA38
                       RTS
LAA38:                 BRK
LAA39:                 DFB     $24                                    ; $
CLEAR:                 BIT     $3E
                       BPL     LAA7E
                       JMP     L8681
SAA41:                 LDA     #$83
                       JSR     osbyte
                       STY     page+1
                       STX     page
NEW:                   LDA     #$02
                       STA     prgtop
                       LDY     page+1
                       STY     prgtop+1
                       LDY     #$00
                       STY     $82
                       STY     $7F
                       STY     pdbugd
                       LDA     #$0D
                       STA     (page),Y
                       INY
                       LDA     #$FF
                       STA     (page),Y
LAA63:                 LDA     prgtop
                       STA     vartop
                       STA     lomem
                       LDA     prgtop+1
                       STA     vartop+1
                       STA     lomem+1
                       LDA     #$84
                       JSR     osbyte
                       JSR     SAAA5
                       LDA     #$00
                       STA     closed
                       LDY     #$E9
                       DFB     $2C          ; BIT - skip the next instruction.
LAA7E:                 LDY     #$B5
                       LDA     #$00
LAA82:                 STA     $0400,Y
                       DEY
                       BMI     LAA82
                       LDA     #$01
                       AND     $33
                       ORA     $2F
                       ORA     $30
                       ORA     $31
                       ORA     $32
                       BNE     LAAA2
                       LDA     #$4A
                       STA     $2F
                       LDA     #$4D
                       STA     $30
                       LDA     #$56
                       STA     $31
LAAA2:                 JMP     LA743
SAAA5:                 STY     himem+1
                       STY     aestkp+1
                       STY     locall+1
                       STY     localh+1
                       STX     himem
                       STX     aestkp
                       STX     locall
                       STX     localh
                       RTS
SAAB6:                 LDA     #$00
                       DFB     $2C          ; BIT - skips the next instruction.
SAAB9:                 LDA     #$FF
                       STA     $7D
                       JSR     S8967
                       BCS     LAAFC
                       JSR     SAD14
                       LDY     #$01
                       LDA     ($36),Y
                       AND     #$DF
                       TAX
                       LDA     $40
                       CMP     #$40
                       BNE     LAAE6
                       LDY     $28
                       CPY     #$03
                       BNE     LAAE6
                       TXA
                       ASL     
                       ASL     
                       STA     $62
                       LDA     #$04
                       STA     $63
                       INC     txtoff
                       JMP     SB304
LAAE6:                 TXA
                       ASL     
                       TAY
                       LDA     $0400,Y
                       STA     $62
                       LDA     $0401,Y
                       STA     $63
                       BNE     LAB03
LAAF5:                 LDA     $7D
                       BEQ     LAAFC
                       JMP     LAC8C
LAAFC:                 SEC
                       RTS
LAAFE:                 JSR     SAD86
                       BEQ     LAAF5
LAB03:                 LDA     $62
                       CMP     vartop
                       LDA     $63
                       SBC     vartop+1
                       BCC     LAB17
                       LDA     $62
                       CMP     locall
                       LDA     $63
                       SBC     locall+1
                       BCC     LAAFE
LAB17:                 LDA     closed
                       BEQ     LAB20
                       JSR     SAD3F
                       BCC     LAAFE
LAB20:                 JSR     SACD0
                       BCS     LAAFE
                       JSR     S8B08
                       BEQ     LAB2D
                       JMP     LABEB
LAB2D:                 LDA     ($62),Y
                       BEQ     LAB3F
                       INY
                       LDA     ($62),Y
                       TAX
                       INY
                       LDA     ($62),Y
                       JSR     SABE4
                       BCS     LAB42
LAB3D:                 CLC
                       RTS
LAB3F:                 JSR     SAC7C
LAB42:                 JSR     SABF5
                       LDA     $7D
                       BEQ     LAB3D
                       JSR     LB308
                       CPX     #$2C
                       BEQ     LAB3D
                       CPX     #$29
                       BEQ     LAB3D
                       LDY     #$00
                       LDA     ($62),Y
                       STA     $1E
                       STY     $1C
                       STY     $1D
                       LDA     $40
                       PHA
                       JSR     SAD74
LAB64:                 JSR     S8AC0
                       LDA     #$21
                       JSR     SB23F
                       JSR     S8AD6
                       LDY     #$00
                       LDA     ($62),Y
                       STA     $20
                       JSR     SAD74
                       STA     $21
                       JSR     SAD74
                       JSR     SADAC
                       BCC     LABB7
                       LDA     ($62),Y
                       STA     $22
                       JSR     SAD74
                       STA     $23
                       JSR     SAD74
                       LDA     $41
                       CMP     $22
                       LDA     $42
                       SBC     $23
                       BCS     LABB7
                       LDA     $41
                       ADC     $1C
                       STA     $1C
                       LDA     $42
                       ADC     $1D
                       STA     $1D
                       DEC     $1E
                       BEQ     LABB9
                       LDY     #$02
                       LDA     ($62),Y
                       STA     $22
                       INY
                       LDA     ($62),Y
                       JSR     SAD5B
                       JMP     LAB64
LABB7:                 BRK
LABB8:                 DFB     $21                                    ; !
LABB9:                 LDX     $6A
                       CPX     #$29
                       BNE     LABB7
                       LDA     #$05
                       STA     $22
                       PLA
                       STA     $40
                       LDA     #$05
                       BIT     $40
                       BMI     LABD7
                       LDA     #$04
                       BVS     LABD7
                       LDY     #$00
                       LDA     ($62),Y
                       CLC
                       ADC     #$02
LABD7:                 JSR     SAD57
                       CLC
                       LDA     $1C
                       ADC     $62
                       TAX
                       LDA     $1D
                       ADC     $63
SABE4:                 STA     $63
                       STX     $62
                       LDA     $40
                       RTS
LABEB:                 LDA     ($62),Y
                       BNE     LAC01
                       JSR     SAC7C
LABF2:                 JSR     SABE4
SABF5:                 LDY     $28
SABF7:                 DEY
SABF8:                 TYA
                       CLC
                       ADC     txtoff
                       STA     txtoff
                       LDA     $40
                       RTS
LAC01:                 INY
                       LDA     ($62),Y
                       TAX
                       INY
                       LDA     ($62),Y
                       BNE     LABF2
                       JMP     LAAFE
SAC0D:                 JSR     SAC1D
LAC10:                 LDA     aestkp
                       STA     locall
                       LDA     aestkp+1
                       STA     locall+1
                       RTS
LAC19:                 BRK
LAC1A:                 DFB     $20                                    ;  
LAC1B:                 BRK
LAC1C:                 DFB     $14                                    ; .
SAC1D:                 LDA     #$01
                       STA     $6E
                       JSR     S8B08
                       BEQ     LAC19
                       LDA     $40
                       BNE     LAC33
                       JMP     LB045
SAC2D:                 LDA     #$00
                       STA     $6E
                       LDY     $28
LAC33:                 DEY
                       JSR     SABF8
                       INY
                       LDA     #$03
                       LDX     $6E
                       BEQ     LAC45
                       LDA     $40
                       AND     #$01
                       CLC
                       ADC     #$05
LAC45:                 CLC
                       STA     $24
                       TYA
                       ADC     $24
                       STA     $24
                       CLC
                       LDA     vartop
                       ADC     $24
                       TAX
                       LDY     vartop+1
                       BCC     LAC58
                       INY
LAC58:                 CPX     aestkp
                       TYA
                       SBC     aestkp+1
                       BCS     LAC1B
                       JSR     SAD7D
                       LDA     closed
                       BNE     LAC6C
                       STX     vartop
                       STY     vartop+1
                       BEQ     LAC74
LAC6C:                 LDA     $24
                       JSR     SA505
                       JSR     SA4AC
LAC74:                 JSR     SAD94
                       JSR     SB1E4
                       LDY     $28
SAC7C:                 SEC
                       DFB     $24
SAC7E:                 CLC
                       TYA
                       ADC     $62
                       STA     $62
                       TAX
                       LDA     #$00
                       ADC     $63
                       STA     $63
                       RTS
LAC8C:                 LDA     #$ED
                       LDX     pdbugd
                       BNE     LAC94
                       SEC
                       RTS
LAC94:                 STA     $7D
                       LDA     $04EA
                       STA     $62
                       LDA     $04EB
                       JMP     LACA7
LACA1:                 LDA     $38
                       STA     $62
                       LDA     $39
LACA7:                 STA     $63
                       BNE     LACAD
                       SEC
                       RTS
LACAD:                 LDY     #$05
                       LDA     ($62),Y
                       CMP     $7D
                       PHP
                       INY
                       LDA     ($62),Y
                       STA     $38
                       INY
                       LDA     ($62),Y
                       STA     $39
                       JSR     SAC7E
                       PLP
                       BNE     LACA1
                       LDY     #$00
                       JSR     SACD2
                       BCS     LACA1
                       LDA     #$01
                       STA     $40
                       RTS
SACD0:                 LDY     #$01
SACD2:                 STY     $50
LACD4:                 INY
                       LDA     ($62),Y
                       CMP     ($36),Y
                       BEQ     LACEC
                       CPY     $28
                       BEQ     LACE1
                       SEC
                       RTS
LACE1:                 LDA     ($62),Y
                       LDY     $50
                       BEQ     LACFB
                       CMP     #$02
                       RTS
LACEA:                 CLC
                       RTS
LACEC:                 CMP     #$28
                       BEQ     LACEA
                       CPY     $28
                       BCC     LACD4
LACF4:                 JSR     S897D
                       BCS     LACEA
                       SEC
                       RTS
LACFB:                 CMP     #$28
                       BNE     LACF4
                       RTS
SAD00:                 LDA     txtoff
                       LDX     txtptr+1
                       CLC
                       ADC     txtptr
                       TAY
                       BNE     LAD0B
                       DEX
LAD0B:                 TXA
                       ADC     #$00
                       STA     $37
                       DEY
                       STY     $36
                       RTS
SAD14:                 JSR     SAD00
SAD17:                 LDA     #$FF
                       STA     $40
                       LDY     #$01
LAD1D:                 INY
                       LDA     ($36),Y
                       JSR     S897D
                       BCC     LAD1D
                       CMP     #$23
                       BEQ     LAD30
                       CMP     #$24
                       BNE     LAD37
                       LDA     #$00
                       DFB     $2C          ; BIT - skip next instruction.
LAD30:                 LDA     #$40
                       STA     $40
                       INY
                       LDA     ($36),Y
LAD37:                 CMP     #$28
                       BNE     LAD3C
                       INY
LAD3C:                 STY     $28
                       RTS
SAD3F:                 LDA     $62
                       CMP     locall
                       LDA     $63
                       SBC     locall+1
                       BCC     LAD56
                       LDA     $62
                       CMP     localh
                       LDA     $63
                       SBC     localh+1
                       BCS     LAD55
                       SEC
                       RTS
LAD55:                 CLC
LAD56:                 RTS
SAD57:                 STA     $22
                       LDA     #$00
SAD5B:                 STA     $23
SAD5D:                 LDA     $1C
                       LDX     $1D
                       JSR     SB874
                       JSR     SA4BA
                       LDX     #$22
                       JSR     SA43A
                       JSR     S9760
                       LDX     #$1C
                       JMP     LA52A
SAD74:                 INC     $62
                       BNE     LAD7A
                       INC     $63
LAD7A:                 LDA     ($62),Y
                       RTS
SAD7D:                 LDA     vartop+1
                       STA     $63
                       LDA     vartop
                       STA     $62
                       RTS
SAD86:                 LDY     #$01
                       LDA     ($62),Y
                       PHA
                       DEY
                       LDA     ($62),Y
                       STA     $62
                       PLA
                       STA     $63
                       RTS
SAD94:                 LDY     $24
                       LDA     #$00
LAD98:                 DEY
                       STA     ($62),Y
                       BNE     LAD98
                       LDY     $28
                       LDA     #$01
                       DFB     $2C          ; BIT - skip next instruction.
LADA2:                 LDA     ($36),Y
                       STA     ($62),Y
                       LDA     #$00
                       DEY
                       BNE     LADA2
                       RTS
SADAC:                 LDA     $21
                       EOR     #$80
                       STA     $21
                       LDA     $41
                       SEC
                       SBC     $20
                       STA     $41
                       LDA     $42
                       EOR     #$80
                       SBC     $21
                       STA     $42
                       LDA     $21
                       EOR     #$80
                       STA     $21
                       RTS
LADC8:                 PHP
                       INX
                       STX     $79
                       LDX     #$41
                       LDA     #$00
                       JSR     LAE8B
                       PLP
                       BEQ     LADE5
                       LDX     #$00
                       STX     $45
                       LDX     $62
                       LDY     $63
                       LDA     #$02
                       JSR     osword
                       CLC
                       RTS
LADE5:                 LDA     $41
                       LDA     #$82
                       JSR     osbyte
                       INX
                       BEQ     LADF4
                       JMP     LAE0E
LADF2:                 BRK
LADF3:                 DFB     $1B                                    ; .
LADF4:                 LDA     localh
                       CMP     himem
                       BNE     LADF2
                       LDA     localh+1
                       CMP     himem+1
                       BNE     LADF2
                       LDA     #$85
                       LDX     $41
                       JSR     osbyte
                       TXA
                       JSR     SA516
                       JSR     SAAA5
LAE0E:                 LDA     #$16
                       JSR     oswrch
                       LDA     #$00
                       STA     $0B
                       LDA     $41
                       JMP     LBAEC
PSEUDO:                DEC     txtoff
LAE1E:                 JSR     SAE2A
                       JSR     S8B11
                       CPX     #$3B
                       BEQ     LAE1E
                       CLC
                       RTS
SAE2A:                 LDA     #$00
                       STA     $76
                       JSR     S8967
                       BCS     LAE72
LAE33:                 LDA     (txtptr),Y
                       CMP     #$96
                       PHP
                       INY
                       PLP
                       BNE     LAE33
                       LDA     (txtptr),Y
                       CMP     #$3D
                       BNE     LAE72
                       JMP     LAECC
LAE45:                 LDX     #$01
                       STX     $79
                       CMP     #$BF
                       BEQ     LAE6F
                       CMP     #$C1
                       BEQ     LAE6E
                       CMP     #$C3
                       BEQ     LAE64
                       CMP     #$C2
                       BNE     LAE5B
                       DEC     $79
LAE5B:                 SEC
                       SBC     #$BD
                       ASL     
                       TAX
                       LDA     #$00
                       BEQ     LAE8B
LAE64:                 LDA     #$03
                       STA     $79
                       LDX     #$00
                       LDA     #$04
                       BNE     LAE8B
LAE6E:                 INX
LAE6F:                 JMP     LADC8
LAE72:                 PHA
                       LDA     #$FF
                       STA     $79
                       JSR     expr1
                       STA     $40
                       LDA     $79
                       BPL     LAE8F
                       PLA
                       CMP     #$BF
                       BCC     LAE88
                       JMP     LAE45
LAE88:                 JMP     LAF2B
LAE8B:                 JSR     SABE4
                       DFB     $24          ; BIT - skip the next instruction.
LAE8F:                 PLA
                       LDA     $40
                       JSR     SB2EB
                       LDA     $79
                       PHA
                       JSR     S8AC0
                       JSR     SB304
                       TXA
                       PHA
                       CMP     #$3D
                       BNE     LAEA7
                       JSR     FFALSE
LAEA7:                 JSR     SA4BA
                       JSR     SB2E8
                       PLA
                       CMP     #$2D
                       BNE     LAEB5
                       JSR     SA3D6
LAEB5:                 JSR     S8AD6
                       PLA
                       TAX
                       LDY     #$00
LAEBC:                 LDA     (aestkp),Y
                       ADC     $0041,Y
                       STA     ($62),Y
                       INY
                       DEX
                       BPL     LAEBC
                       JSR     S9738
                       CLC
                       RTS
LAECC:                 LDA     txtoff
                       STA     $25
                       JSR     SAAB9
                       BCC     LAF15
                       LDY     $28
                       DEY
LAED8:                 INY
                       LDA     ($36),Y
                       CMP     #$20
                       BEQ     LAED8
                       CMP     #$96
                       BEQ     LAEE9
                       BRK
LAEE4:                 DFB     $20                                    ;  
LAEE5:                 BRK
LAEE6:                 DFB     $1B                                    ; .
LAEE7:                 BRK
LAEE8:                 DFB     $1F                                    ; .
LAEE9:                 JSR     SAC0D
                       LDA     #$00
                       TAX
LAEEF:                 LDA     $40
                       CMP     #$01
                       BEQ     LAEE5
                       PHA
                       TXA
                       PHA
                       JSR     S8B11
                       JSR     S8AC0
                       JSR     expri
                       STA     $40
                       JSR     S8AD6
                       PLA
                       BNE     LAF0C
                       JSR     SB02C
LAF0C:                 PLA
                       STA     $7E
SAF0F:                 BEQ     LAF37
                       BPL     LAF5D
                       BMI     LAF54
LAF15:                 JSR     LB308
                       CPX     #$96
                       BEQ     LAEEF
                       CPX     #$01
                       BEQ     LAF6E
                       CMP     #$01
                       BEQ     LAEE5
                       LDA     $25
                       STA     txtoff
                       JMP     LAE72
LAF2B:                 LDX     $40
                       DEX
                       BEQ     LAEE5
                       LDA     $40
                       BNE     LAF78
LAF34:                 JSR     SAFA3
LAF37:                 LDY     #$00
                       LDA     ($62),Y
                       CMP     $4F
                       BCC     LAEE7
                       INY
                       LDA     $4F
                       STA     ($62),Y
                       BEQ     LAF52
                       INC     $4F
LAF48:                 INY
                       LDA     $05FE,Y
                       STA     ($62),Y
                       CPY     $4F
                       BNE     LAF48
LAF52:                 CLC
                       RTS
LAF54:                 LDA     $40
                       JSR     SB2F1
                       CLC
                       JMP     S9C70
LAF5D:                 LDA     $40
                       JSR     SB2EB
                       LDY     #$03
LAF64:                 LDA     $0041,Y
                       STA     ($62),Y
                       DEY
                       BPL     LAF64
                       CLC
                       RTS
LAF6E:                 LDA     $25
                       STA     txtoff
                       JSR     expr1
                       JMP     LAF34
LAF78:                 LDA     $40
                       PHA
                       JSR     S8AC0
                       JSR     SAFC5
                       BEQ     LAF9A
                       TSX
                       LDY     $0101,X
                       STY     $62
                       LDY     $0102,X
                       STY     $63
                       LDY     $0103,X
                       TAX
                       TYA
                       CPX     #$2B
                       JSR     SB55D
                       STA     $40
LAF9A:                 JSR     S8AD6
                       PLA
                       TAY
                       BPL     LAF5D
                       BMI     LAF54
SAFA3:                 JSR     S8AC0
                       LDA     $76
                       BEQ     LAFB0
                       LDA     $77
                       PHA
                       LDA     $78
                       PHA
LAFB0:                 LDA     $76
                       PHA
                       JSR     SAFC5
                       BEQ     LAFBF
                       PLA
                       JSR     S8AD6
                       JMP     LB5AB
LAFBF:                 PLA
                       BNE     LAFDC
                       JMP     S8AD6
SAFC5:                 JSR     SB304
                       TXA
                       PHA
                       CMP     #$3D
                       BEQ     LAFD3
                       LDA     $40
                       JSR     SB2A3
LAFD3:                 JSR     expri
                       STA     $40
                       PLA
                       CMP     #$3D
                       RTS
LAFDC:                 PLA
                       STA     $78
                       PLA
                       STA     $77
                       JSR     S8AD6
                       LDA     $77
                       ORA     $78
                       BNE     LAFEE
                       PLA
                       PLA
                       RTS
LAFEE:                 JSR     SB317
                       JSR     SB287
                       LDX     $77
                       LDY     #$00
                       LDA     (aestkp),Y
                       STA     $76
                       BEQ     LB00F
                       LDY     #$01
LB000:                 LDA     (aestkp),Y
                       STA     $05FF,X
                       CPX     $78
                       BCS     LB025
                       CPY     $76
                       INY
                       INX
                       BCC     LB000
LB00F:                 LDY     $78
                       CPY     $4F
                       BEQ     LB022
                       INY
LB016:                 LDA     $05FF,Y
                       STA     $05FF,X
                       CPY     $4F
                       INX
                       INY
                       BCC     LB016
LB022:                 DEX
                       STX     $4F
LB025:                 LDY     #$00
                       LDA     (aestkp),Y
                       JMP     L9753
SB02C:                 DEC     $63
                       LDY     #$FF
                       LDA     #$00
                       STA     ($62),Y
                       INC     $63
                       RTS
DIM:                   JSR     LB045
                       JSR     S8B11
                       CPX     #$2C
                       BEQ     DIM
                       CLC
                       JMP     LAC10
LB045:                 JSR     SAAB6
                       BCS     LB04F
                       BRK
LB04B:                 DFB     $26                                    ; &
SB04C:                 JSR     SAD14
LB04F:                 LDA     #$22
                       ADC     $28
                       STA     $24
                       JSR     SA505
                       JSR     SA4AC
                       JSR     SAD94
                       LDX     $28
                       INX
                       TXA
                       STA     ($62),Y
                       STX     $1F
                       TAY
                       DEY
                       LDA     #$00
                       STA     ($62),Y
                       LDX     #$01
                       STX     $1C
                       DEX
                       STX     $1D
                       STX     $1E
                       JSR     SABF5
                       JSR     S8B08
                       BNE     LB0E1
                       LDA     $40
                       PHA
                       INC     $1F
                       INC     $1F
LB084:                 INC     $1E
                       JSR     SB23D
                       LDY     $1F
                       CPX     #$3A
                       BNE     LB095
                       JSR     SA4CB
                       JSR     SB23D
LB095:                 LDY     $1F
                       LDA     (aestkp),Y
                       STA     $21
                       DEY
                       LDA     (aestkp),Y
                       STA     $20
                       JSR     SADAC
                       BCS     LB0A7
                       BRK
LB0A6:                 DFB     $25                                    ; %
LB0A7:                 JSR     SA417
                       LDY     $1F
                       INY
                       INY
                       STY     $1F
                       INC     $1F
                       INC     $1F
                       JSR     SA4CB
                       CPX     #$2C
                       BEQ     LB084
                       LDY     #$00
                       LDA     (aestkp),Y
                       TAY
                       LDA     $1E
                       STA     (aestkp),Y
                       PLA
                       STA     $40
                       INY
                       STY     $1F
LB0CA:                 LDY     $1F
                       INY
                       INY
                       LDA     (aestkp),Y
                       STA     $22
                       INY
                       LDA     (aestkp),Y
                       STA     $23
                       INY
                       STY     $1F
                       JSR     SB1C1
                       DEC     $1E
                       BNE     LB0CA
LB0E1:                 LDA     #$05
                       BIT     $40
                       BMI     LB110
                       LDA     #$04
                       BVS     LB110
                       JSR     LB308
                       CPX     #$8E
                       BNE     LB105
                       JSR     SB2E8
                       LDA     $42
                       JSR     SBA58
                       BNE     LB103
                       LDA     $41
                       CLC
                       ADC     #$02
                       BCC     LB10C
LB103:                 BRK
LB104:                 DFB     $1F                                    ; .
LB105:                 LDA     #$28
                       JSR     SB872
                       LDA     #$2A
LB10C:                 LDY     #$00
                       STY     $40
LB110:                 STA     $22
                       LDA     #$00
                       STA     $23
                       JSR     SB1C1
                       LDA     $1C
                       CLC
                       ADC     $1F
                       STA     $1C
                       BCC     LB124
                       INC     $1D
LB124:                 LDA     closed
                       BEQ     LB18A
                       LDA     $1D
                       BNE     LB146
                       LDA     $1C
                       CMP     $24
                       BCS     LB146
                       LDA     #$00
                       JSR     SB13A
                       JMP     LB16F
SB13A:                 CLC
                       ADC     aestkp
                       STA     $2B
                       LDA     aestkp+1
                       ADC     #$00
                       STA     $2C
                       RTS
LB146:                 LDA     $24
                       JSR     SB13A
                       SEC
                       LDA     $2B
                       SBC     $1C
                       STA     $2B
                       LDA     $2C
                       SBC     $1D
                       STA     $2C
                       BCC     LB1BF
                       LDA     vartop
                       CMP     $2B
                       LDA     vartop+1
                       SBC     $2C
                       BCS     LB1BF
                       LDY     #$00
LB166:                 LDA     (aestkp),Y
                       STA     ($2B),Y
                       INY
                       CPY     $1F
                       BCC     LB166
LB16F:                 LDA     $2B
                       STA     aestkp
                       LDA     $2C
                       STA     aestkp+1
                       JSR     SA4AC
                       LDA     $2B
                       CLC
                       ADC     $1C
                       STA     $29
                       LDA     $2C
                       ADC     $1D
                       STA     $2A
                       JMP     LB1B6
LB18A:                 LDY     #$FF
LB18C:                 INY
                       LDA     (aestkp),Y
                       STA     (vartop),Y
                       CPY     $1F
                       BCC     LB18C
                       LDA     $24
                       JSR     S9755
                       CLC
                       LDA     vartop
                       ADC     $1C
                       TAX
                       LDA     vartop+1
                       ADC     $1D
                       TAY
                       CPX     aestkp
                       SBC     aestkp+1
                       BCS     LB1BF
                       JSR     SAD7D
                       STX     vartop
                       STY     vartop+1
                       STX     $29
                       STY     $2A
LB1B6:                 LDA     $40
                       BEQ     LB212
                       JSR     SB203
                       BNE     LB1D2
LB1BF:                 BRK
LB1C0:                 DFB     $14                                    ; .
SB1C1:                 JSR     SAD5D
                       LDA     $44
                       ORA     $43
                       BNE     LB1BF
                       RTS
LB1CB:                 LDA     #$00
                       STA     ($2B),Y
                       JSR     S89C4
LB1D2:                 LDA     $2B
                       CMP     $29
                       LDA     $2C
                       SBC     $2A
                       BCC     LB1CB
LB1DC:                 JSR     SB1E4
                       LDY     $28
                       JMP     SAC7C
SB1E4:                 LDY     #$01
                       LDA     ($62),Y
                       AND     #$DF
                       ASL     
                       TAX
                       LDA     $0401,X
                       STA     ($62),Y
                       DEY
                       LDA     $0400,X
                       STA     ($62),Y
                       LDA     $62
                       STA     $0400,X
                       LDA     $63
                       STA     $0401,X
                       CLC
                       RTS
SB203:                 LDA     $1F
                       CLC
                       ADC     $62
                       STA     $2B
                       LDA     #$00
                       TAY
                       ADC     $63
                       STA     $2C
                       RTS
LB212:                 JSR     SB203
                       DEC     $22
                       LDX     $22
                       DEX
LB21A:                 LDY     #$00
                       TXA
                       STA     ($2B),Y
                       LDA     #$00
LB221:                 INY
                       STA     ($2B),Y
                       CPY     $22
                       BNE     LB221
                       TYA
                       ADC     $2B
                       STA     $2B
                       BCC     LB231
                       INC     $2C
LB231:                 LDA     $2B
                       CMP     $29
                       LDA     $2C
                       SBC     $2A
                       BCC     LB21A
                       BCS     LB1DC
SB23D:                 LDA     #$25
SB23F:                 PHA
                       LDA     $24
                       PHA
                       LDA     $1E
                       PHA
                       LDA     $1D
                       PHA
                       LDA     $1C
                       PHA
                       JSR     SB3F0
                       PLA
                       STA     $1C
                       PLA
                       STA     $1D
                       PLA
                       STA     $1E
                       PLA
                       STA     $24
                       LDA     $44
                       CMP     $43
                       BNE     LB271
                       CMP     #$FF
                       BEQ     LB269
                       CMP     #$00
                       BNE     LB271
LB269:                 EOR     $42
                       BMI     LB271
                       PLA
                       JMP     S8B11
LB271:                 PLA
                       BRK
                       BRK
SB274:                 LDA     $40
                       BEQ     SB287
                       BMI     LB29D
SB27A:                 LDY     #$03
LB27C:                 LDA     ($62),Y
                       STA     $0041,Y
                       DEY
                       BPL     LB27C
                       LDA     #$40
                       RTS
SB287:                 LDY     #$01
                       LDA     ($62),Y
                       TAY
                       STA     $4F
                       BEQ     LB29A
LB290:                 INY
                       LDA     ($62),Y
                       STA     $05FE,Y
                       DEY
                       DEY
                       BNE     LB290
LB29A:                 LDA     #$00
                       RTS
LB29D:                 JSR     S9C98
                       LDA     #$FF
                       RTS
SB2A3:                 TAY
                       BEQ     SB317
                       BPL     LB2B1
                       JSR     S9B01
                       JSR     SA471
                       JMP     L9D9E
LB2B1:                 JMP     SA4BA
LB2B4:                 BEQ     LB2B9
                       JSR     SA3D6
LB2B9:                 LDX     #$04
                       CLC
                       LDY     #$00
LB2BE:                 LDA     (aestkp),Y
                       ADC     $0041,Y
                       STA     $0041,Y
                       INY
                       DEX
                       BNE     LB2BE
                       BVC     SB2DF
                       ROR     $44
                       ROR     $43
                       ROR     $42
                       ROR     $41
                       JSR     S9BA4
                       INC     $47
                       JSR     S9738
                       JMP     LB5A2
SB2DF:                 JSR     S9738
                       JMP     LB932
SB2E5:                 JSR     SA4BA
SB2E8:                 JSR     expri
SB2EB:                 TAY
                       BPL     LB2F9
                       JMP     L9CC7
SB2F1:                 TAY
                       BMI     LB2F9
                       JSR     S9BA4
                       LDA     #$FF
LB2F9:                 LDX     $6A
                       RTS
SB2FC:                 LDA     #$40
                       DFB     $2C          ; BIT - skip the next instruction.
SB2FF:                 LDA     #$00
                       JSR     SB2A3
SB304:                 PHA
LB305:                 INC     txtoff
                       DFB     $24          ; BIT - skips over the PHA.
LB308:                 PHA
                       LDY     txtoff
                       LDA     (txtptr),Y
                       CMP     #$20
                       BEQ     LB305
                       STA     $6A
                       TAX
                       PLA
                       CLC
                       RTS
SB317:                 LDY     #$00
                       LDA     aestkp
                       LDA     $4F
                       JSR     SA507
                       LDY     $4F
                       BEQ     LB32C
LB324:                 LDA     $05FF,Y
                       STA     (aestkp),Y
                       DEY
                       BNE     LB324
LB32C:                 LDA     $4F
                       STA     (aestkp),Y
                       RTS
SB331:                 STA     $79
                       LDX     #$62
                       JSR     SA522
                       JSR     FFALSE
                       LDA     $79
                       TAY
LB33E:                 LDA     ($62),Y
                       STA     $0041,Y
                       DEY
                       BPL     LB33E
                       JMP     LB932
SB349:                 JSR     S8AC0
                       LDA     #$FF
                       STA     $76
                       JSR     SB2FF
                       JSR     SB304
                       CPX     #$3A
                       BNE     LB35F
                       JSR     FFALSE
                       BCC     LB368
LB35F:                 JSR     SB3F0
                       LDX     $6A
                       CPX     #$29
                       BEQ     LB374
LB368:                 JSR     SB2FC
                       CPX     #$29
                       BEQ     LB37A
                       JSR     SB3F0
                       BNE     LB37F
LB374:                 JSR     SA4BA
                       JMP     LB37F
LB37A:                 LDA     #$FF
                       JSR     SB872
LB37F:                 JSR     S8AD6
                       JSR     SB304
                       LDY     #$04
                       LDA     (aestkp),Y
                       TAX
                       BEQ     LB3D0
                       BIT     $44
                       BPL     LB399
                       SEC
                       LDA     $41
LB393:                 ADC     (aestkp),Y
                       STA     $41
                       BCC     LB393
LB399:                 LDA     $41
                       BEQ     LB3D0
                       CPX     $41
                       BCS     LB3A2
                       TXA
LB3A2:                 TAX
                       JSR     SA4D5
                       LDY     #$00
                       BIT     $44
                       BPL     LB3B5
                       SEC
                       LDA     $41
LB3AF:                 ADC     (aestkp),Y
                       STA     $41
                       BCC     LB3AF
LB3B5:                 LDA     $41
                       BEQ     LB3BF
                       CPX     $41
                       BCS     LB3C1
                       BCC     LB3D3
LB3BF:                 LDA     #$01
LB3C1:                 STA     $77
                       STX     $78
                       JSR     S9740
                       LDA     $77
                       JSR     SB3DB
                       JMP     LB63D
LB3D0:                 JSR     S9738
LB3D3:                 LDX     #$00
LB3D5:                 JSR     S9740
                       JMP     LB8EB
SB3DB:                 TAY
                       STX     $52
                       LDX     #$00
                       DEY
LB3E1:                 INY
                       INX
                       LDA     $05FF,Y
                       STA     $05FF,X
                       CPY     $52
                       BCC     LB3E1
                       JMP     LB8EB
SB3F0:                 JSR     expr1
                       JMP     SB2EB
expri:                 INC     txtoff
expr1:                 JSR     expr2
LB3FB:                 CPX     #$89
                       BEQ     LB405
                       CPX     #$87
                       BEQ     LB405
                       TAY
LB404:                 RTS
LB405:                 TAY
                       TXA
                       PHA
                       TYA
                       JSR     SA4B5
                       JSR     expr2
                       JSR     SB2EB
                       LDY     #$03
                       PLA
                       CMP     #$89
                       BEQ     LB429
LB419:                 LDA     (aestkp),Y
                       EOR     $0041,Y
                       STA     $0041,Y
                       DEY
                       BPL     LB419
LB424:                 JSR     SB2DF
                       BNE     LB3FB
LB429:                 LDA     (aestkp),Y
                       ORA     $0041,Y
                       STA     $0041,Y
                       DEY
                       BPL     LB429
                       BMI     LB424
expr2:                 JSR     expr3
LB439:                 CPX     #$85
                       BNE     LB404
                       JSR     SA4B5
                       JSR     expr3
                       JSR     SB2EB
                       LDY     #$03
LB448:                 LDA     (aestkp),Y
                       AND     $0041,Y
                       STA     $0041,Y
                       DEY
                       BPL     LB448
                       JSR     SB2DF
                       BCC     LB439
LB458:                 JSR     SB317
                       INC     txtoff
                       JSR     SBA36
                       JSR     FFALSE
LB463:                 LDY     #$00
                       LDA     $4F
                       CMP     (aestkp),Y
                       BCC     LB481
                       LDA     (aestkp),Y
                       BEQ     LB47D
                       STA     $51
LB471:                 INY
                       LDA     (aestkp),Y
                       CMP     $05FF,Y
                       BNE     LB48C
                       CPY     $51
                       BCC     LB471
LB47D:                 INC     $41
                       BNE     LB484
LB481:                 JSR     FFALSE
LB484:                 JSR     S9740
                       JSR     LB932
                       BCC     LB49E
LB48C:                 LDA     #$02
                       LDX     $4F
                       CPX     #$02
                       BCC     LB481
                       JSR     SB3DB
                       INC     $41
                       BNE     LB463
expr3:                 JSR     expr4
LB49E:                 LDY     #$00
SB4A0:                 STY     $7F
                       CPX     #$3E
                       BEQ     LB4B7
                       CPX     #$3C
                       BEQ     LB4D3
                       CPX     #$3D
                       BEQ     LB4F6
                       CPX     #$8A
                       BEQ     LB458
                       LDY     $7F
                       BNE     LB4F8
                       RTS
LB4B7:                 JSR     SB304
                       CPX     #$3D
                       PHP
                       BNE     LB4C1
                       INC     txtoff
LB4C1:                 JSR     SB504
                       BCS     LB4CC
LB4C6:                 PLP
LB4C7:                 JSR     FFALSE
                       BNE     LB49E
LB4CC:                 BNE     LB4FE
                       PLP
                       BNE     LB4C7
                       BEQ     LB4FF
LB4D3:                 JSR     SB304
                       CPX     #$3E
                       BEQ     LB4ED
                       CPX     #$3D
                       PHP
                       BNE     LB4E1
                       INC     txtoff
LB4E1:                 JSR     SB504
                       BCC     LB4FE
                       BNE     LB4C6
                       PLP
                       BNE     LB4C7
                       BEQ     LB4FF
LB4ED:                 INC     txtoff
                       JSR     SB504
                       BNE     LB4FF
                       BEQ     LB4C7
LB4F6:                 INC     txtoff
LB4F8:                 JSR     SB504
                       BNE     LB4C7
                       PHP
LB4FE:                 PLP
LB4FF:                 JSR     FTRUE
                       BNE     LB49E
SB504:                 TAY
                       BEQ     LB519
                       JSR     SB2F1
                       JSR     SA471
                       JSR     SBA36
                       JSR     SB2F1
                       JSR     SA49D
                       JMP     L96FF
LB519:                 JSR     SB317
                       JSR     SBA36
                       LDX     $4F
                       LDY     #$00
                       LDA     (aestkp),Y
                       STA     $50
                       CMP     $4F
                       BCS     LB52C
                       TAX
LB52C:                 STX     $51
LB52E:                 CPY     $51
                       BEQ     LB53C
                       INY
                       LDA     (aestkp),Y
                       CMP     $05FF,Y
                       BNE     LB540
                       BEQ     LB52E
LB53C:                 LDA     $50
                       CMP     $4F
LB540:                 PHP
                       LDA     $50
                       JSR     L9753
                       PLP
                       RTS
expr4:                 JSR     expr5
LB54B:                 CPX     #$2B
                       PHP
                       BEQ     LB556
                       CPX     #$2D
                       BEQ     LB556
                       PLP
                       RTS
LB556:                 PLP
                       JSR     SB569
                       JMP     LB54B
SB55D:                 PHP
                       TAY
                       PHP
                       LDA     $40
                       PLP
                       BEQ     LB5AB
                       BPL     LB574
                       BMI     LB593
SB569:                 PHP
                       INC     txtoff
                       TAY
                       BEQ     LB5A7
                       BMI     LB58D
                       JSR     SB5D0
LB574:                 TAY
                       BMI     LB57B
                       PLP
                       JMP     LB2B4
LB57B:                 JSR     S9B01
                       JSR     SA4D5
                       JSR     S9BA4
                       JSR     SA471
                       JSR     L9D9E
                       JMP     LB596
LB58D:                 JSR     SA471
                       JSR     expr5
LB593:                 JSR     SB2F1
LB596:                 JSR     SA49D
                       PLP
                       BEQ     LB59F
                       JSR     LA3C2
LB59F:                 JSR     S9DC2
LB5A2:                 LDA     #$FF
                       JMP     LB308
LB5A7:                 PLP
                       JSR     SB5D0
LB5AB:                 LDY     #$00
                       LDX     $4F
                       LDA     (aestkp),Y
                       PHA
                       CLC
                       ADC     $4F
                       STA     $4F
                       PLA
                       BEQ     LB5CA
                       BCC     LB5BE
                       BRK
LB5BD:                 DFB     $1F                                    ; .
LB5BE:                 LDY     $4F
LB5C0:                 LDA     $05FF,X
                       STA     $05FF,Y
                       DEY
                       DEX
                       BNE     LB5C0
LB5CA:                 LDA     $4F
                       TAX
                       JMP     LB3D5
SB5D0:                 JSR     SB2A3
expr5:                 JSR     expr6
LB5D6:                 CPX     #$86
                       BEQ     LB601
                       CPX     #$88
                       BEQ     LB618
                       CPX     #$2A
                       BEQ     LB623
                       CPX     #$2F
                       BEQ     LB5E7
                       RTS
LB5E7:                 JSR     SB2F1
                       JSR     SA471
                       INC     txtoff
                       JSR     expr6
                       JSR     SB2F1
                       JSR     SA49D
                       JSR     S9F78
LB5FB:                 JSR     LB5A2
                       JMP     LB5D6
LB601:                 JSR     S9686
                       ROL     $52
                       ROL     $53
                       ROL     $54
                       ROL     $55
                       LDA     $50
                       LDX     #$52
                       JSR     S97AF
LB613:                 JSR     LB932
                       BNE     LB5D6
LB618:                 JSR     S9686
                       LDA     $51
                       JSR     S97AD
                       JMP     LB613
LB623:                 JSR     SB2F1
                       JSR     SB635
                       JSR     SB2F1
                       JSR     SA49D
                       JSR     S9F29
                       JMP     LB5FB
SB635:                 JSR     SB2A3
                       INC     txtoff
expr6:                 JSR     expr7
LB63D:                 CPX     #$5E
                       BEQ     LB64C
                       CPX     #$01
                       BEQ     LB646
                       RTS
LB646:                 JSR     SB349
                       JMP     LB63D
LB64C:                 JSR     SB2F1
                       JSR     SA471
                       INC     txtoff
                       JSR     expr7
                       JSR     SB2F1
                       LDA     $47
                       CMP     #$87
                       BCS     LB69D
                       JSR     S9D57
                       BNE     LB672
                       JSR     SA49D
                       JSR     S9C98
                       LDA     $61
                       JSR     SA378
                       BMI     LB63D
LB672:                 JSR     S9C65
                       JSR     SA4AC
                       JSR     S9C98
                       LDA     $61
                       JSR     SA378
LB680:                 JSR     S9C62
                       JSR     SA49D
                       JSR     S9C98
                       JSR     FLN
                       JSR     LA344
                       JSR     FEXP
                       JSR     SA0AB
                       JSR     S9F29
                       JSR     LB5A2
                       BMI     LB63D
LB69D:                 JSR     S9C65
                       JSR     S9F63
                       BNE     LB680
expr7:                 JSR     expr8
LB6A8:                 CPX     #$3F
                       BEQ     LB6B1
                       CPX     #$21
                       BEQ     LB6B4
                       RTS
LB6B1:                 LDY     #$00
                       DFB     $2C          ; Bit - skip the next instruction.
LB6B4:                 LDY     #$03
                       TAX
                       TYA
                       PHA
                       TXA
                       JSR     SA4B5
                       JSR     SB6EE
                       LDA     #$00
                       JSR     LB2B4
                       PLA
                       JSR     SB331
                       BNE     LB6A8
SB6CB:                 CMP     #$2D
                       BCS     LB706
                       JSR     SB304
                       ASL     
                       TAY
                       LDA     funtab+1,Y
                       PHA
                       LDA     funtab,Y
                       PHA
                       CPY     #$4A
                       BEQ     expr8
                       BCS     LB706
                       CPY     #$16
                       BCC     LB706
                       CPY     #$1C
                       BCC     expr8
                       CPY     #$3A
                       BCC     LB6F4
SB6EE:                 JSR     expr8
                       JMP     SB2EB
LB6F4:                 JSR     expr8
                       JSR     SB2F1
                       PLA
                       TAX
                       PLA
                       JSR     SB703
                       JMP     LB5A2
SB703:                 PHA
                       TXA
                       PHA
LB706:                 RTS
SB707:                 JSR     SB70D
                       JMP     SB2EB
SB70D:                 INC     txtoff
expr8:                 TSX
                       CPX     #$20
                       BCS     LB716
                       BRK
LB715:                 DFB     $1C                                    ; .
LB716:                 JSR     LB308
                       TXA
                       SEC
                       SBC     #$97
                       BCC     LB725
                       JSR     SB6CB
                       LDX     $6A
                       RTS
LB725:                 CPX     #$28
                       BNE     LB72F
                       JSR     expri
                       JMP     SB304
LB72F:                 CPX     #$2B
                       BNE     LB737
                       INC     txtoff
                       BNE     expr8
LB737:                 CPX     #$2D
                       BNE     LB74C
                       JSR     SB70D
                       PHA
                       TAY
                       BPL     LB747
                       JSR     LA3C2
                       PLA
                       RTS
LB747:                 JSR     SA3D6
                       PLA
                       RTS
LB74C:                 JSR     S896A
                       BCS     LB768
                       JSR     SAAB9
                       BCC     LB758
                       BRK
LB757:                 DFB     $20                                    ;  
LB758:                 CMP     #$01
                       BNE     LB762
                       JSR     SBD61
                       JMP     LB308
LB762:                 JSR     SB274
                       JMP     LB308
LB768:                 CPX     #$26
                       BNE     LB79C
                       INC     txtoff
                       JSR     FFALSE
                       LDY     txtoff
                       LDX     #$00
LB775:                 LDA     (txtptr),Y
                       JSR     isxdig
                       BCS     LB797
                       CMP     #$3A
                       BCC     LB782
                       SBC     #$37
LB782:                 ASL     
                       ASL     
                       ASL     
                       ASL     
                       LDX     #$03
LB788:                 ASL     
                       ROL     $41
                       ROL     $42
                       ROL     $43
                       ROL     $44
                       DEX
                       BPL     LB788
                       INY
                       BNE     LB775
LB797:                 STY     txtoff
                       JMP     LB932
LB79C:                 CPX     #$22
                       BCC     LB7C8
                       BNE     LB7D5
SB7A2:                 INC     txtoff
                       LDY     txtoff
                       LDX     #$00
LB7A8:                 LDA     (txtptr),Y
                       CMP     #$22
                       BEQ     LB7BB
                       CMP     #$0D
                       BEQ     LB822
LB7B2:                 STA     $0600,X
                       INC     txtoff
                       INX
                       INY
                       BNE     LB7A8
LB7BB:                 INC     txtoff
                       LDY     txtoff
                       LDA     (txtptr),Y
                       CMP     #$22
                       BEQ     LB7B2
                       JMP     LB8EB
LB7C8:                 LDA     #$03
                       DFB     $2C          ; BIT - skip over the next instruction.
LB7CB:                 LDA     #$00
                       PHA
                       JSR     SB707
                       PLA
                       JMP     SB331
LB7D5:                 CPX     #$7E
                       BNE     LB812
                       JSR     SB707
                       LDX     #$00
                       STX     $4F
                       LDY     #$00
LB7E2:                 LDA     $0041,Y
                       PHA
                       AND     #$0F
                       STA     $54,X
                       PLA
                       LSR     
                       LSR     
                       LSR     
                       LSR     
                       INX
                       STA     $54,X
                       INX
                       INY
                       CPY     #$04
                       BNE     LB7E2
LB7F8:                 DEX
                       BEQ     LB7FF
                       LDA     $54,X
                       BEQ     LB7F8
LB7FF:                 LDA     $54,X
                       CMP     #$0A
                       BCC     LB807
                       ADC     #$06
LB807:                 ADC     #$30
                       JSR     L994D
                       DEX
                       BPL     LB7FF
                       JMP     LB8ED
LB812:                 CPX     #$3F
                       BEQ     LB7CB
                       CPX     #$2E
                       BCC     LB822
                       CPX     #$3A
                       BCS     LB822
                       CPX     #$2F
                       BNE     LB823
LB822:                 RTS
LB823:                 JSR     S996D
                       JMP     LB308
FPOINT:                JSR     SB3F0
                       JSR     SB2E5
                       JSR     SB304
                       LDA     $41
                       PHA
                       LDA     $42
                       PHA
                       JSR     SA4D5
                       PLA
                       STA     $44
                       PLA
                       STA     $43
                       LDX     #$41
                       LDY     #$00
                       LDA     #$09
                       JSR     osword
                       LDA     $45
                       JMP     LB861
FSGN:                  JSR     SB855
                       JMP     SB2F1
SB855:                 JSR     S9ABD
                       BEQ     FFALSE
                       BPL     SB86A
LB85C:                 JMP     FTRUE
FEOD:                  LDA     $2E
LB861:                 BMI     LB85C
                       DFB     $2C          ; BIT - skips the next instruction.
FWIDTH:                LDA     $0A
                       DFB     $2C          ; BIT - skips the next instruction.
FCOUNT:                LDA     $0B
                       DFB     $2C          ; BIT - skips the next instruction.
SB86A:                 LDA     #$01
                       DFB     $2C          ; BIT - skips the next instruction.
FLEN:                  LDA     $4F
                       DFB     $2C          ; BIT - skips the next instruction.
FFALSE:                LDA     #$00
SB872:                 LDX     #$00
SB874:                 STA     $41
LB876:                 STX     $42
LB878:                 LDY     #$00
                       STY     $43
                       STY     $44
LB87E:                 JMP     LB932
FZONE:                 LDX     #$03
LB883:                 LDA     $0400,X
                       STA     $41,X
                       DEX
                       BPL     LB883
                       BMI     LB87E
FORD:                  LDA     $0600
                       LDX     $4F
                       BEQ     LB85C
                       BNE     SB872
FINKEY:                JSR     SB937
                       TYA
LB89A:                 BNE     LB85C
                       TXA
                       JMP     SB872
FINKEYS:               JSR     SB937
                       TYA
                       BNE     LB8AC
                       STX     $0600
                       JMP     LB8E9
LB8AC:                 LDX     #$00
                       BEQ     LB8EB
FSIZE:                 SEC
                       LDA     prgtop+1
                       SBC     page+1
                       TAX
                       LDA     prgtop
                       BCS     SB874
FPAGE:                 LDX     page+1
                       LDA     #$00
                       BEQ     SB874
FFREE:                 SEC
                       LDA     aestkp
                       SBC     vartop
                       STA     $41
                       LDA     aestkp+1
                       SBC     vartop+1
                       TAX
                       JMP     LB876
FGET:                  JSR     S83FF
                       JMP     SB872
FVPOS:                 LDA     #$86
                       JMP     LB94E
FPOS:                  LDA     #$86
                       JSR     osbyte
                       TXA
                       JMP     SB872
FGETS:                 JSR     S83FF
                       STA     $0600
LB8E9:                 LDX     #$01
LB8EB:                 STX     $4F
LB8ED:                 LDA     #$00
                       JMP     LB308
FCHRS:                 LDA     $41
                       STA     $0600
                       JMP     LB8E9
FSTRS:                 JSR     S97D0
                       JMP     LB8ED
FABS:                  LDY     #$00
                       STY     $45
                       RTS
FADVAL:                LDY     #$FF
                       LDX     $41
                       LDA     #$80
                       JSR     osbyte
                       STX     $41
                       STY     $42
                       JMP     LB878
SB915:                 JMP     ($0041)
FUSR:                  LDA     $040C
                       LSR     
                       LDX     $0460
                       LDY     $0464
                       LDA     $0404
                       JSR     SB915
                       PHP
                       STA     $41
                       STX     $42
                       STY     $43
                       PLA
                       STA     $44
LB932:                 LDA     #$40
                       JMP     LB308
SB937:                 LDX     $41
                       LDY     $44
                       LDA     #$81
                       JMP     osbyte
FTIME:                 LDA     #$01
                       LDX     #$41
                       LDY     #$00
                       JSR     osword
                       JMP     LB932
FMODE:                 LDA     #$87
LB94E:                 JSR     osbyte
                       TYA
                       JMP     SB872
FVAL:                  JSR     S86F5
                       JSR     SB317
                       JSR     S8AE5
                       TSX
                       LDA     $2D
                       PHA
                       BNE     LB966
                       STX     $2D
LB966:                 LDA     aestkp
                       STA     txtptr
                       LDA     aestkp+1
                       STA     txtptr+1
                       INC     txtptr
                       BNE     LB974
                       INC     txtptr+1
LB974:                 JSR     S8B17
                       JSR     S8B86
                       LDY     #$5C
                       JSR     S93D3
                       BCS     LB998
                       LDA     #$00
                       STA     txtoff
                       JSR     expr1
                       STA     $7D
                       JSR     LB025
                       PLA
                       STA     $2D
                       JSR     S8AF6
                       LDA     $7D
                       JMP     LB308
LB998:                 LDA     erflag
                       BRK
LB99B:                 BRK
                       DFB     $21
SB99D:                 JSR     SA3D6
FNOT:                  JSR     SA417
                       JMP     SA3D6
FRND:                  JSR     SB3F0
                       LDX     $6A
                       CPX     #$2C
                       BNE     LB9D6
                       JSR     SB99D
                       LDA     #$40
                       JSR     SB2E5
                       JSR     LB2B4
                       JSR     SBA54
                       BEQ     LB99B
                       JSR     SA3D6
                       LDA     $44
                       BMI     LB99B
                       LDA     #$04
                       JSR     SA505
                       JSR     SA402
                       LDA     #$00
                       JSR     LB2B4
                       JMP     SB304
LB9D6:                 JSR     SA3F0
                       JMP     SB304
funtab:                DFW     FFALSE-1, FPI-1, FTRUE-1, FCOUNT-1
                       DFW     FEOD-1,   FGET-1, FPOS-1, FSIZE-1
                       DFW     FFREE-1, FVPOS-1, FGETS-1, FLEN-1
                       DFW     FORD-1, FVAL-1, FACS-1, FASN-1
                       DFW     FATN-1, FCOS-1, FDEG-1, FEXP-1
                       DFW     FLN-1, FLOG-1, FRAD-1, FSIN-1
                       DFW     FSQR-1, FTAN-1, FINT-1, FSGN-1
                       DFW     FABS-1, FADVAL-1, FEOF-1, FEXT-1
                       DFW     FINKEY-1, FNOT-1, FUSR-1, FCHRS-1
                       DFW     FINKEYS-1, FSTRS-1, FRND-1, FPOINT-1
                       DFW     FMODE-1, FPAGE-1, FTIME-1, FWIDTH-1
                       DFW     FZONE-1
SBA36:                 LDY     $7F
                       BMI     LBA3D
                       JMP     expr4
LBA3D:                 PHA
                       JSR     expr1
                       STA     $50
                       PLA
                       EOR     $50
                       AND     #$40
                       BEQ     LBA4E
                       BRK
LBA4B:                 DFB     $17, $00, $1B                          ; ...
LBA4E:                 LDA     $50
                       RTS
SBA51:                 JSR     SB3F0
SBA54:                 LDA     $41
                       ORA     $42
SBA58:                 ORA     $43
                       ORA     $44
                       RTS
SBA5D:                 PHA
                       BMI     LBA67
                       BEQ     LBA6F
                       JSR     SA4D5
                       PLA
                       RTS
LBA67:                 JSR     SA49D
                       JSR     S9C98
                       PLA
                       RTS
LBA6F:                 JSR     S9740
                       PLA
                       RTS
LBA74:                 PLP
                       BNE     LBAE0
                       JSR     FNPROC
                       CPX     #$EC
                       BNE     LBAE0
                       INC     txtoff
IF:                    JSR     SBA51
                       PHP
                       JSR     S89AF
                       BEQ     LBA74
                       PLP
                       BEQ     LBAE0
                       LDA     (txtptr),Y
                       INC     txtoff
                       JMP     S852B
CASE:                  JSR     expr1
                       PHA
                       JSR     SB2A3
                       JSR     FNPROC
                       BCC     LBAA7
LBA9F:                 PLA
                       PHA
                       JSR     SBA5D
                       JSR     SB2A3
LBAA7:                 JSR     SB304
                       LDY     #$FF
                       CPX     #$8A
                       BEQ     LBAD3
                       CPX     #$EF
                       BEQ     LBACD
                       PLA
                       PHA
                       JSR     SB4A0
LBAB9:                 JSR     SBA54
                       BNE     LBACD
                       CPX     #$2C
                       BEQ     LBA9F
                       JSR     FNPROC
                       CPX     #$E9
                       BEQ     LBACD
                       CPX     #$EB
                       BEQ     LBA9F
LBACD:                 PLA
                       JSR     SBA5D
                       CLC
                       RTS
LBAD3:                 JSR     LB458
                       JMP     LBAB9
ELSE:                  JSR     FNPROC
                       CPX     #$E5
                       BNE     ELSE
LBAE0:                 CLC
                       RTS
SBAE2:                 LDA     $41
                       JSR     oswrch
                       LDA     $42
                       DFB     $2C          ; BIT - skip the next instruction.
CLG                    LDA     #$10                       
LBAEC:                 JSR     oswrch
                       CLC
                       RTS
GCOL:                  LDA     #$12
                       DFB     $2C          ; BIT - skip the next instruction.
COLOUR:                LDA     #$11
                       JSR     oswrch
VDU:                   JSR     SB3F0
                       LDA     $41
                       JSR     oswrch
                       CPX     #$3B
                       BNE     LBB0A
                       LDA     $42
                       JSR     oswrch
LBB0A:                 JSR     S89B1
                       BEQ     LBB14
                       JSR     S89AF
                       BNE     VDU
LBB14:                 CLC
                       RTS
PLOT:                  JSR     SB3F0
                       INC     txtoff
                       LDX     $41
                       DFB     $2C          ; BIT - skip the next instruction.
DRAW:                  LDX     #$05
                       DFB     $2C          ; BIT - skip the next instruction.
MOVE:                  LDX     #$04
                       LDA     #$19
                       JSR     oswrch
                       TXA
                       JSR     oswrch
                       JSR     SB3F0
                       JSR     SBAE2
                       JSR     SB2E8
                       JMP     SBAE2
ENVELP:                LDA     #$08
                       SEC
                       DFB     $2C          ; BIT - skip the next instruction.
SOUND:                 LDA     #$07
                       PHA
                       ROR     $84
                       DEC     txtoff
                       LDX     #$00
LBB45:                 TXA
                       PHA
                       JSR     SB2E8
                       PLA
                       TAX
                       LDA     $41
                       STA     $06A0,X
                       INX
                       BIT     $84
                       BMI     LBB5C
                       LDA     $42
                       STA     $06A0,X
                       INX
LBB5C:                 JSR     S89B4
                       BNE     LBB45
                       LDX     #$A0
                       LDY     #$06
                       PLA
                       JSR     osword
                       CLC
                       RTS
LBB6B:                 LDY     lstkp
                       LDA     $0500,Y
                       STA     txtptr
                       DEY
                       LDA     $0500,Y
                       STA     txtptr+1
                       DEY
                       SEC
                       STY     lstkp
                       RTS
UNTIL:                 JSR     SBA51
                       BEQ     LBB6B
                       DEC     lstkp
                       DEC     lstkp
                       CLC
                       RTS
SBB88:                 BMI     LBB93
                       LDA     $7D
                       JSR     SB2EB
                       STA     $7E
                       BNE     LBBB5
LBB93:                 LDA     $7D
                       JSR     SB2F1
                       STA     $7E
                       JSR     S8AC0
                       INC     lstkp
                       LDY     lstkp
                       STY     $62
                       LDA     #$05
                       STA     $63
                       JSR     S9C70
                       LDA     lstkp
                       CLC
                       ADC     #$04
                       STA     lstkp
                       JSR     S8AD6
                       RTS
LBBB5:                 LDX     #$00
                       LDY     lstkp
                       INY
LBBBA:                 LDA     $41,X
                       STA     $0500,Y
                       INX
                       INY
                       CPX     #$04
                       BNE     LBBBA
                       STY     lstkp
                       RTS
SBBC8:                 TAY
                       LDA     $0500,Y
                       STA     $63
                       INY
                       LDA     $0500,Y
                       STA     $62
                       INY
                       RTS
SBBD6:                 LDX     #$00
LBBD8:                 LDA     $0500,Y
                       STA     $41,X
                       INX
                       INY
                       CPX     #$04
                       BNE     LBBD8
                       RTS
SBBE4:                 LDY     lstkp
                       LDA     $0500,Y
                       PHP
                       TYA
                       SEC
                       SBC     #$0C
                       PLP
                       RTS
SBBF0:                 JSR     SBBE4
                       PHP
                       JSR     SBBC8
                       PLP
                       BMI     LBC3E
                       LDA     $0508,Y
                       STA     $7E
                       TYA
                       PHA
                       JSR     SB27A
                       JSR     SA4BA
                       PLA
                       TAY
                       JSR     SBBD6
                       LDY     #$00
                       LDA     $44
                       EOR     #$80
                       STA     $44
                       SEC
                       LDA     (aestkp),Y
                       SBC     $41
                       STA     $41
                       INY
                       LDA     (aestkp),Y
                       SBC     $42
                       STA     $42
                       INY
                       LDA     (aestkp),Y
                       SBC     $43
                       STA     $43
                       INY
                       LDA     (aestkp),Y
                       LDY     #$00
                       EOR     #$80
                       SBC     $44
                       ORA     $41
                       ORA     $42
                       ORA     $43
                       JSR     S9738
                       JMP     LBC55
LBC3E:                 JSR     S8AC0
                       LDA     $0506,Y
                       STA     $7E
                       LDA     #$05
                       STA     $63
                       STY     $62
                       JSR     S9C98
                       JSR     S8AD6
                       JSR     L96FF
LBC55:                 BEQ     LBC65
                       ROR     
                       EOR     $7E
                       BPL     LBC65
                       SEC
                       RTS
LBC5E:                 LDA     lstkp
                       SEC
                       SBC     #$0D
                       STA     lstkp
LBC65:                 CLC
                       RTS
FOR:                   JSR     LAECC
                       LDA     $7E
                       PHA
                       LDY     lstkp
                       INY
                       LDA     $63
                       STA     $0500,Y
                       INY
                       LDA     $62
                       STA     $0500,Y
                       STY     lstkp
                       JSR     expri
                       STA     $7D
                       PLA
                       PHA
                       JSR     SBB88
                       LDX     $6A
                       CPX     #$8C
                       BNE     LBC92
                       JSR     SB86A
                       BNE     LBC95
LBC92:                 JSR     expri
LBC95:                 STA     $7D
                       JSR     SB304
                       PLA
                       PHA
                       JSR     SBB88
                       PLA
                       INC     lstkp
                       LDY     lstkp
                       STA     $0500,Y
                       JSR     S89B1
                       BEQ     LBCCF
LBCAC:                 JSR     SBBF0
                       BCS     LBC5E
SBCB1:                 LDA     txtoff
                       PHA
                       TAY
                       LDA     (txtptr),Y
                       STY     $82
                       INC     txtoff
                       JSR     S852B
                       JSR     SBD26
                       JSR     chkesc
                       PLA
                       STA     txtoff
                       BNE     LBCAC
NEXT:                  JSR     LBB6B
                       JSR     SBD26
LBCCF:                 JSR     SBBF0
                       BCC     REPEAT
                       JSR     LBC5E
FNPROC:                LDY     #$04
                       LDA     (txtptr),Y
                       STA     $50
LBCDD:                 JSR     S8A01
                       BMI     LBD1C
                       LDY     #$04
                       LDA     (txtptr),Y
                       CMP     $50
                       BNE     LBCDD
SBCEA:                 LDY     #$05
                       STY     txtoff
                       JMP     LB308
WHILE:                 JSR     SBA51
                       BEQ     LBD1E
                       JSR     S89AF
                       BEQ     REPEAT
                       LDA     $6A
                       INC     txtoff
                       JSR     chkesc
                       JSR     S852B
                       JSR     SBCEA
                       INC     txtoff
                       BNE     WHILE
REPEAT:                LDY     lstkp
                       INY
                       LDA     txtptr+1
                       STA     $0500,Y
                       LDA     txtptr
                       INY
                       STA     $0500,Y
                       STY     lstkp
LBD1C:                 CLC
                       RTS
LBD1E:                 JSR     S89AF
                       BNE     LBD1C
                       JMP     FNPROC
SBD26:                 JSR     SBBE4
                       PHP
                       JSR     SBBC8
                       INY
                       INY
                       INY
                       INY
                       INY
                       PLP
                       BMI     LBD4A
                       JSR     SBBD6
                       CLC
                       LDY     #$00
                       LDX     #$03
LBD3D:                 LDA     $0041,Y
                       ADC     ($62),Y
                       STA     ($62),Y
                       INY
                       DEX
                       BPL     LBD3D
                       CLC
                       RTS
LBD4A:                 JSR     S8AC0
                       STY     $62
                       LDA     #$05
                       STA     $63
                       JSR     S9C98
                       JSR     S8AD6
                       JSR     S9DC2
                       JSR     S9C70
                       CLC
                       RTS
SBD61:                 JSR     SAD17
                       LDA     $83
                       PHA
                       LDA     $40
                       STA     $83
                       JSR     SBD7F
                       PLA
                       STA     $83
                       LDA     $40
                       CLC
                       RTS
EXEC:                  JSR     SAD14
                       LDA     #$EE
                       JSR     LAC94
                       BCS     LBD85
SBD7F:                 LDA     pdbugd
                       BNE     LBD87
                       BRK
LBD84:                 DFB     $20                                    ;  
LBD85:                 BRK
                       DFB     $20
LBD87:                 TSX
                       TXA
                       CLC
                       ADC     aestkp
                       JSR     SA50E
                       LDY     #$00
                       TXA
                       STA     (aestkp),Y
LBD94:                 INX
                       INY
                       LDA     $0100,X
                       STA     (aestkp),Y
                       CPX     #$FF
                       BNE     LBD94
                       LDX     #$FD
                       TXS
                       LDA     lstkp
                       JSR     SA507
                       LDY     lstkp
                       BEQ     LBDB3
LBDAB:                 LDA     $0500,Y
                       STA     (aestkp),Y
                       DEY
                       BNE     LBDAB
LBDB3:                 LDA     lstkp
                       STA     (aestkp),Y
                       STY     lstkp
                       LDA     #$19
                       JSR     SA505
                       LDY     #$17
LBDC0:                 LDA     locall,Y
                       STA     (aestkp),Y
                       DEY
                       BPL     LBDC0
                       LDA     aestkp
                       STA     locall
                       LDA     aestkp+1
                       STA     locall+1
                       LDA     $62
                       SEC
                       SBC     #$07
                       STA     $16
                       LDA     $63
                       SBC     #$00
                       STA     $17
                       DEC     $28
                       LDY     $28
                       JSR     SABF7
                       JSR     LB308
                       TXA
                       LDY     #$18
                       STA     (aestkp),Y
                       CMP     #$28
                       BEQ     LBDF3
                       JMP     LBE63
LBDF3:                 JSR     SBEF1
                       LDA     $28
                       CLC
                       ADC     #$07
                       STA     $18
                       BCC     LBE02
LBDFF:                 JSR     SBEF1
LBE02:                 JSR     SBEF7
                       JSR     S8B11
                       JSR     LB308
                       CPX     #$90
                       BNE     LBE12
                       JMP     LBE8D
LBE12:                 LDA     closed
                       PHA
                       LDA     #$FF
                       STA     closed
                       JSR     SAD14
                       LDA     $40
                       BNE     LBE25
                       JSR     SB04C
                       BCC     LBE28
LBE25:                 JSR     SAC1D
LBE28:                 PLA
                       STA     closed
                       LDA     $40
                       PHA
                       JSR     S8AC0
                       JSR     LB308
                       JSR     SBEEE
                       INC     txtoff
                       JSR     expr1
                       JSR     LB308
                       STA     $40
                       JSR     S8AD6
                       PLA
                       PHA
                       EOR     $40
                       AND     #$40
                       BEQ     LBE4E
LBE4C:                 BRK
                       DFB     $29
LBE4E:                 JSR     SB02C
                       PLA
                       JSR     SAF0F
LBE55:                 LDY     txtoff
                       LDA     (txtptr),Y
                       LDY     $18
                       CMP     ($16),Y
                       BNE     LBE4C
                       CMP     #$2C
                       BEQ     LBDFF
LBE63:                 INC     txtoff
                       LDA     txtoff
                       LDY     #$07
                       STA     (locall),Y
                       JSR     SBEF7
                       JSR     S8AA9
                       JSR     S8EA7
                       LDX     #$00
                       CMP     #$FD
                       BNE     LBE7B
                       DEX
LBE7B:                 STX     closed
                       LDX     #$01
LBE7F:                 LDA     locall,X
                       STA     localh,X
                       LDA     $04,X
                       STA     locall,X
                       DEX
                       BPL     LBE7F
                       JMP     L8777
LBE8D:                 INC     txtoff
                       JSR     SBEEE
                       JSR     SB304
                       JSR     SAAB9
                       BCC     LBE9E
                       BRK
                       DFB     $20
LBE9C:                 BRK
                       DFB     $29
LBE9E:                 JSR     LB308
                       JSR     SBEF1
                       JSR     SBEF7
                       JSR     S8AC0
                       LDA     $40
                       PHA
                       LDA     closed
                       PHA
                       LDA     #$FF
                       STA     closed
                       JSR     SAD14
                       JSR     SAC2D
                       PLA
                       STA     closed
                       JSR     LB308
                       JSR     SBEEE
                       PLA
                       CMP     $40
                       BNE     LBE9C
                       JSR     S8B08
                       BNE     LBEE2
LBECD:                 LDY     txtoff
                       LDA     (txtptr),Y
                       LDY     $18
                       CMP     ($16),Y
                       BNE     LBE9C
                       INC     txtoff
                       INC     $18
                       CMP     #$29
                       BNE     LBECD
                       JSR     LB308
LBEE2:                 LDY     #$00
                       PLA
                       STA     ($62),Y
                       INY
                       PLA
                       STA     ($62),Y
                       JMP     LBE55
SBEEE:                 JSR     SBEF7
SBEF1:                 LDX     #$19
                       DFB     $2C          ; BIT - skip the next instruction.
SBEF4:                 LDX     $18
                       DFB     $2C          ; BIT - skip the next instruction.
SBEF7:                 LDX     #$16
                       LDY     #$02
LBEFB:                 LDA     txtptr,Y
                       PHA
                       LDA     $02,X
                       STA     txtptr,Y
                       PLA
                       STA     $02,X
                       DEX
                       DEY
                       BPL     LBEFB
                       RTS
END:                   CPX     #$EE
                       BEQ     LBF38
                       CPX     #$ED
                       BEQ     LBF27
                       CPX     #$F2
                       BEQ     LBF22
                       TXA
                       BMI     LBF21
                       PLA
                       PLA
LBF1D:                 LDA     #$00
                       STA     $82
LBF21:                 RTS
LBF22:                 INC     txtoff
                       JMP     LBB6B
LBF27:                 BRK
LBF28:                 DFB     $28                                    ; (
LBF29:                 BRK
LBF2A:                 DFB     $17                                    ; .
RETURN:                JSR     expr1
                       PHA
                       EOR     $83
                       AND     #$40
                       BNE     LBF29
                       PLA
                       STA     $40
LBF38:                 LDY     #$18
                       LDA     (localh),Y
                       CMP     #$28
                       BEQ     LBF44
                       LDA     closed
                       BEQ     LBF5F
LBF44:                 LDX     #$B4
LBF46:                 STX     $36
                       LDA     #$04
                       STA     $37
LBF4C:                 LDY     #$00
                       LDA     ($36),Y
                       STA     $62
                       INY
                       LDA     ($36),Y
                       STA     $63
LBF57:                 LDA     $63
                       BNE     LBF9F
                       DEX
                       DEX
                       BMI     LBF46
LBF5F:                 LDA     localh
                       STA     aestkp
                       LDA     localh+1
                       STA     aestkp+1
                       LDY     #$17
LBF69:                 LDA     (aestkp),Y
                       STA     locall,Y
                       DEY
                       BPL     LBF69
                       LDA     #$18
                       JSR     L9753
                       LDY     #$00
                       LDA     (aestkp),Y
                       STA     lstkp
                       TAY
                       BEQ     LBF89
LBF7F:                 LDA     (aestkp),Y
                       STA     $0500,Y
                       DEY
                       BNE     LBF7F
                       LDA     lstkp
LBF89:                 JSR     L9753
                       LDA     (aestkp),Y
                       TAX
                       TXS
LBF90:                 INY
                       INX
                       LDA     (aestkp),Y
                       STA     $0100,X
                       CPX     #$FF
                       BNE     LBF90
                       TYA
                       JMP     L9753
LBF9F:                 JSR     SAD3F
                       BCS     LBFAE
                       LDA     $62
                       STA     $36
                       LDA     $63
                       STA     $37
                       BCC     LBF4C
LBFAE:                 JSR     SAD86
                       INY
                       STA     ($36),Y
                       DEY
                       LDA     $62
                       STA     ($36),Y
                       BCS     LBF57
IMPORT:                JSR     SAAB6
                       BCC     LBFD4
                       LDA     txtoff
                       PHA
                       LDA     closed
                       PHA
                       LDA     #$00
                       STA     closed
                       JSR     SAAB6
                       PLA
                       STA     closed
                       BCC     LBFD6
                       BRK
LBFD3:                 DFB     $20                                    ;  
LBFD4:                 BRK
                       DFB     $26
LBFD6:                 PLA
                       STA     txtoff
                       JSR     S8AC0
                       JSR     SAC2D
                       JSR     S8B08
                       BNE     LBFEB
LBFE4:                 JSR     S8B11
                       CPX     #$29
                       BNE     LBFE4
LBFEB:                 PLA
                       LDY     #$00
                       STA     ($62),Y
                       INY
                       PLA
                       STA     ($62),Y
                       JSR     S8B11
                       CPX     #$2C
                       BEQ     IMPORT
                       CLC
                       JMP     LAC10
                       ROL     
