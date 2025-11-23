;; Vietnamese screen chars creation
;; Original source code: FONT16.ASM
;; Built to Borland Turbo Assembler

code    SEGMENT
        ASSUME CS:code,DS:code,ES:code
        ORG 100h
start:
        JMP Begin

;; 128 dec ASCII

AF_     DB 0,0,30h,18h,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,0,0,0
AS_     DB 0,0,0Ch,18h,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,0,0,0
AR      DB 0,38h,8,10h,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,0,0,0
AX_     DB 0,0,36h,6Ch,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,0,0,0
AJ      DB 0,0,0,0,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,18h,18h,0

;;

AW      DB 0,0,6Ch,38h,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,0,0,0
AWF     DB 20h,10h,6Ch,38h,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,0,0,0
AWS     DB 8,10h,6Ch,38h,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,0,0,0
AWR     DB 38h,10h,6Ch,38h,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,0,0,0
AWX     DB 14h,28h,6Ch,38h,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,0,0,0
AWJ     DB 0,0,6Ch,38h,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,18h,18h,0

;;

UW_to   DB 0,0,0C7h,0C7h,0C6h,0C6h,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,0,0,0
DNB     DB 0FEh,63h,63h,63h,0FEh,0,0E3h,0D3h,0CBh,0C7h,0,0FEh,63h,7Eh,63h,0FEh
ADX     DB 7Eh,0C3h,0C3h,0FFh,0C3h,0,0FEh,63h,63h,0FEh,0,0C3h,66h,3Ch,66h,0C3h

;;

AA      DB 0,0,38h,6Ch,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,0,0,0
AAF     DB 40h,20h,38h,6Ch,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,0,0,0
AAS_    DB 4,8,38h,6Ch,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,0,0,0
AAR     DB 1Ch,8,38h,6Ch,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,0,0,0
AAX     DB 14h,28h,38h,6Ch,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,0,0,0
AAJ     DB 0,0,38h,6Ch,0,78h,0Ch,7Ch,0CCh,0CCh,0CCh,76h,0,18h,18h,0

;;

EF      DB 0,0,30h,18h,0,7Ch,0C6h,0FEh,0C0h,0C0h,0C6h,7Ch,0,0,0,0
ES_     DB 0,0,0Ch,18h,0,7Ch,0C6h,0FEh,0C0h,0C0h,0C6h,7Ch,0,0,0,0
ER      DB 0,38h,8,10h,0,7Ch,0C6h,0FEh,0C0h,0C0h,0C6h,7Ch,0,0,0,0
EX_     DB 0,0,36h,6Ch,0,7Ch,0C6h,0FEh,0C0h,0C0h,0C6h,7Ch,0,0,0,0
EJ      DB 0,0,0,0,0,7Ch,0C6h,0FEh,0C0h,0C0h,0C6h,7Ch,0,18h,18h,0

;;

EE      DB 0,0,38h,6Ch,0,7Ch,0C6h,0FEh,0C0h,0C0h,0C6h,7Ch,0,0,0,0
EEF     DB 40h,20h,38h,6Ch,0,7Ch,0C6h,0FEh,0C0h,0C0h,0C6h,7Ch,0,0,0,0
EES     DB 4,8,38h,6Ch,0,7Ch,0C6h,0FEh,0C0h,0C0h,0C6h,7Ch,0,0,0,0
EER     DB 1Ch,8,38h,6Ch,0,7Ch,0C6h,0FEh,0C0h,0C0h,0C6h,7Ch,0,0,0,0
EEX     DB 14h,28h,38h,6Ch,0,7Ch,0C6h,0FEh,0C0h,0C0h,0C6h,7Ch,0,0,0,0
EEJ     DB 0,0,38h,6Ch,0,7Ch,0C6h,0FEh,0C0h,0C0h,0C6h,7Ch,0,18h,18h,0

;;

IF_     DB 0,0,30h,18h,0,38h,18h,18h,18h,18h,18h,3Ch,0,0,0,0
IS_     DB 0,0,0Ch,18h,0,38h,18h,18h,18h,18h,18h,3Ch,0,0,0,0
IR      DB 0,38h,8,10h,0,38h,18h,18h,18h,18h,18h,3Ch,0,0,0,0
IX      DB 0,0,36h,6Ch,0,38h,18h,18h,18h,18h,18h,3Ch,0,0,0,0
IJ      DB 0,0,18h,18h,0,38h,18h,18h,18h,18h,18h,3Ch,0,18h,18h,0

;;

AW_to   DB 6Ch,38h,10h,38h,6Ch,0C6h,0C6h,0FEh,0C6h,0C6h,0C6h,0C6h,0,0,0,0
AA_to   DB 38h,6Ch,10h,38h,6Ch,0C6h,0C6h,0FEh,0C6h,0C6h,0C6h,0C6h,0,0,0,0
D_to    DB 0,0,0F8h,6Ch,66h,66h,0F6h,66h,66h,66h,6Ch,0F8h,0,0,0,0
d_be    DB 0,0,0Ch,1Eh,0Ch,3Ch,6Ch,0CCh,0CCh,0CCh,0CCh,76h,0,0,0,0
EE_to   DB 38h,6Ch,0FEh,66h,62h,68h,78h,68h,60h,62h,66h,0FEh,0,0,0,0
OO_to   DB 38h,6Ch,38h,6Ch,0C6h,0C6h,0C6h,0C6h,0C6h,0C6h,6Ch,38h,0,0,0,0
OW_to   DB 0,6,3Ch,6Ch,0C6h,0C6h,0C6h,0C6h,0C6h,0C6h,6Ch,38h,0,0,0,0

;;

OF_     DB 0,0,30h,18h,0,7Ch,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,0,0,0
OS_     DB 0,0,0Ch,18h,0,7Ch,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,0,0,0
OR_     DB 0,38h,8,10h,0,7Ch,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,0,0,0
OX      DB 0,0,36h,6Ch,0,7Ch,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,0,0,0
OJ      DB 0,0,0,0,0,7Ch,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,18h,18h,0

;; 224 dec ASCII

OO      DB 0,0,38h,6Ch,0,7Ch,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,0,0,0
OOF     DB 40h,20h,38h,6Ch,0,7Ch,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,0,0,0
OOS     DB 4,8,38h,6Ch,0,7Ch,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,0,0,0
OOR     DB 1Ch,8,38h,6Ch,0,7Ch,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,0,0,0
OOX     DB 14h,28h,38h,6Ch,0,7Ch,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,0,0,0
OOJ     DB 0,0,38h,6Ch,0,7Ch,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,18h,18h,0

;;

OW      DB 0,0,0,0,3,7Fh,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,0,0,0
OWF     DB 0,0,30h,18h,3,7Fh,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,0,0,0
OWS     DB 0,0,0Ch,18h,3,7Fh,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,0,0,0
OWR     DB 0,38h,8,10h,3,7Fh,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,0,0,0
OWX     DB 0,0,36h,6Ch,3,7Fh,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,0,0,0
OWJ     DB 0,0,0,0,3,7Fh,0C6h,0C6h,0C6h,0C6h,0C6h,7Ch,0,18h,18h,0

;;

UF      DB 0,0,30h,18h,0,0CCh,0CCh,0CCh,0CCh,0CCh,0CCh,76h,0,0,0,0
US      DB 0,0,0Ch,18h,0,0CCh,0CCh,0CCh,0CCh,0CCh,0CCh,76h,0,0,0,0
UR      DB 0,38h,8,10h,0,0CCh,0CCh,0CCh,0CCh,0CCh,0CCh,76h,0,0,0,0
UX      DB 0,0,36h,6Ch,0,0CCh,0CCh,0CCh,0CCh,0CCh,0CCh,76h,0,0,0,0
UJ      DB 0,0,0,0,0,0CCh,0CCh,0CCh,0CCh,0CCh,0CCh,76h,0,18h,18h,0

;;

UW      DB 0,0,0,0,3,0CFh,0CCh,0CCh,0CCh,0CCh,0CCh,76h,0,0,0,0
UWF     DB 0,0,30h,18h,3,0CFh,0CCh,0CCh,0CCh,0CCh,0CCh,76h,0,0,0,0
UWS     DB 0,0,0Ch,18h,3,0CFh,0CCh,0CCh,0CCh,0CCh,0CCh,76h,0,0,0,0
UWR     DB 0,38h,8,10h,3,0CFh,0CCh,0CCh,0CCh,0CCh,0CCh,76h,0,0,0,0
UWX     DB 0,0,36h,6Ch,3,0CFh,0CCh,0CCh,0CCh,0CCh,0CCh,76h,0,0,0,0
UWJ     DB 0,0,0,0,3,0CFh,0CCh,0CCh,0CCh,0CCh,0CCh,76h,0,18h,18h,0

;;

Cubic   DB 0,70h,98h,30h,18h,98h,70h,0,0,0,0,0,0,0,0,0

;; Total: 69 Vietnamese, 3 special chars

Begin:
        mov     BH,16   ;16 pixel lines
        xor     BL,BL   ;Default font table
        mov     CX,48   ;From 128 to 175 (80hex-AFhex)
        mov     DX,128  ;80 hex
        lea     BP,AF_
        call    FONT
        mov     CX,24   ;From 229 to 252 (E5hex-FChex)
        mov     DX,229  ;E5 hex
        lea     BP,OO
        call    FONT
        int     20h
Font:
        xor     AL,AL   ;If AL=10hex, BH=8 : Char. will be cut!!!
        mov     AH,11h
        int     10h     ;To change font
        ret
code    ENDS
        END start
