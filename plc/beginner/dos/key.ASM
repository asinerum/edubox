;; VN keyboard & simple printer
;; Original source code: DZK.ASM
;; Built to Borland Turbo Assembler

;;

Sp_char     EQU 24                  ;24 special char.
Char_in_end EQU 251                 ;The char "uwj", Code 251hex

;;

Be_a    EQU 128
Be_aw   EQU 133
Be_aa   EQU 142
Be_e    EQU 148
Be_ee   EQU 153
Be_i    EQU 159
Be_o    EQU 171                     ;The latest version
Be_oo   EQU 229
Be_ow   EQU 235
Be_u    EQU 241
Be_uw   EQU 246

;;

To_aw   EQU 164
To_aa   EQU 165
To_dd   EQU 166
Be_dd   EQU 167
To_ee   EQU 168
To_oo   EQU 169
To_ow   EQU 170

;;

To_uw   EQU 139

;;

codes SEGMENT
      ASSUME DS:codes,CS:codes,ES:codes
      ORG 100h
start:
      jmp    set_resident

;;

Int9 PROC FAR                       ;Call DZK when another running
      pushf                         ;Certainly gets!
      call   CS:int9_ptr            ;Call for old INT 9 that saved
      cli
      push   AX
      push   ES
      xor    AX,AX
      mov    ES,AX
      mov    AX,word ptr ES:[417h]  ;Address of Keyb.Scan. byte [0:0417hex]
      and    AX,CS:k_mask           ;Take bits from that byte
      cmp    AX,CS:k_mask           ;SHIFT pressed?
      pop    ES
      pop    AX
      jne    No_lock                ;If SHIFT not pressed..
      cmp    CS:recur,0             ;If pressed, then check RECUR
      je     Lock_                  ;If RECUR=0 (Not active DZK)..
      mov    CS:recur,0             ;If RECUR=1 (Active), then deactive 
      iret                          ;..by put RECUR=0 and return 
      Lock_:                        ;(RECUR=0, i.e. DZK not active), then
      mov    CS:recur,1             ;active by put RECUR=1,
      iret                          ;..and return from interrupt
      No_lock:                      ;(SHIFT not pressed),
      cmp    CS:recur,0             ;..then check RECUR
      je     Finish                 ;If RECUR=0 (Not active DZK), return
      call   Fix_char               ;If RECUR=1 (Active), then fix character
      Finish:
      iret
Int9 ENDP

;;

Int17 PROC FAR                      ;For printer of all kinds
       or     AH,AH                 ;Print??
       jnz    Print_fin             ;No printing command found
       cmp    AL,Be_a               ;128dec=80hex
       jb     Print_fin             ;Noneed to change print code
       sti
       push   ES      
       push   DI
       push   CX
       push   CS
       pop    ES
       mov    DI,offset Char_tab
       mov    CX,Char_num           ;71 char.
       repnz  scasb
       jnz    Normal_
       add    DI,Char_num-1         ;DI+=1, so skip 71-1
       mov    Al,CS:[DI]
       Normal_:
       pop    CX
       pop    DI
       pop    ES
       Print_fin:
      jmp     CS:int17_ptr          ;"JMP", not "CALL"
Int17 ENDP

;;

Fix_char PROC NEAR
      push   ES
      push   DI 
      push   AX
      push   BX
      push   CX
      xor    AX,AX                  
      mov    ES,AX                  ;[0:041Ahex]=Show Keyb.Buff.End (KBE)
      mov    BX,word ptr ES:[41Ah]  ;Move to BX for comparison

;;

      cmp    BX,1Eh                 ;KBE is in 1st place of buffer??
      jz     Kt_1E                   
      cmp    BX,20h                 ;KBE is in 2nd word-place of buffer?
      jz     Kt_20
      cmp    BX,22h                 ;KBE is in 3rd word-place of buffer?
      jz     Kt_22
      cmp    BX,24h                 ;KBE is in 4th word-place of buffer?
      jz     Kt_24
      jmp    Kt_00

;;    

      Kt_1E:
      mov    AL,byte ptr ES:[43Ch]  ;Last Word in buffer (2 next bytes)
      call   Check_last      
      jnc    BX_1E
      jmp    Fin
      BX_1E:
      mov    char1,AL               ;..is Last Character (Last-Char)
      mov    AL,byte ptr ES:[43Ah]  ;Word (2 bytes) before there,
      mov    char2,AL               ;..is Before-Last-Char
      mov    AL,byte ptr ES:[438h]  ;Word before above,
      mov    char3,AL               ;..is Bef-Bef-Last-Char
      mov    AL,byte ptr ES:[436h]
      mov    char4,AL               ;..is Bef-Bef-Bef-Last-Char
      jmp    Take_last              ;To checking routine

;;    

      Kt_20:
      mov    AL,byte ptr ES:[41Eh]  ;First word-place,
      call   Check_last      
      jnc    BX_20
      jmp    Fin
      BX_20:
      mov    char1,AL               ;..is Last-Char
      mov    AL,byte ptr ES:[43Ch]  ;Last word-place is 2nd char
      mov    char2,AL               
      mov    AL,byte ptr ES:[43Ah]
      mov    char3,AL               
      mov    AL,byte ptr ES:[438h]
      mov    char4,AL               
      jmp    Take_last

;;    

      Kt_22:
      mov    AL,byte ptr ES:[420h]  ;2nd Word place in buffer
      call   Check_last      
      jnc    BX_22
      jmp    Fin
      BX_22:
      mov    char1,AL               
      mov    AL,byte ptr ES:[41Eh]
      mov    char2,AL               
      mov    AL,byte ptr ES:[43Ch]
      mov    char3,AL               
      mov    AL,byte ptr ES:[43Ah]
      mov    char4,AL               
      jmp    Take_last

;;    

      Kt_24:                         
      mov    AL,byte ptr ES:[422h]  ;3rd word-place..
      call   Check_last      
      jnc    BX_24
      jmp    Fin
      BX_24:
      mov    char1,AL               
      mov    AL,byte ptr ES:[420h]
      mov    char2,AL               
      mov    AL,byte ptr ES:[41Eh]
      mov    char3,AL               
      mov    AL,byte ptr ES:[43Ch]
      mov    char4,AL               
      jmp    Take_last

;; Another cases of KBE      

      Kt_00:
      add    BX,3FEh                ;Add to [KBE] 3FEhex (400hex-2), 
      mov    AL,byte ptr ES:[BX]    
      call   Check_last      
      jnc    BX_00
      jmp    Fin
      BX_00:
      mov    char1,AL               ;..for taking last Char in 
      dec    BX
      dec    BX                     ;Word before above..
      mov    AL,byte ptr ES:[BX]
      mov    char2,AL               ;Bef-Last-Char
      dec    BX
      dec    BX                     ;Word before above..
      mov    AL,byte ptr ES:[BX]
      mov    char3,AL               ;Bef-Bef-Last-Char
      dec    BX
      dec    BX                     ;Word before above..
      mov    AL,byte ptr ES:[BX]
      mov    char4,AL               ;Bef-Bef-Bef-Last-Char

;; Check Last Character In (A,E,O,W and F,S,R,X,J)     

      Take_last:
      mov    AL,char1               ;Take Last Char
      and    AL,5Fh                 ;Convert to uppercase

;; Start to check Double-Fix-Char case (AA,EE,OO,AW,OW,UW)

      cmp    AL,'A'                 ;..Last-Char is "A","a" ?
      jz     Make_aa
      cmp    AL,'D'                 ;Last-Char is "D","d" ?
      jz     Make_dd
      cmp    AL,'E'                 ;Last-Char is "E","e" ?
      jz     Make_ee
      cmp    AL,'O'                 ;Last Char is "O","o" ?
      jz     Make_oo

;;                      

      jmp    Make_w                 ;If not..,jump to check [W]

;;                      

      Make_aa:
      cmp    char2,'A'              ;Bef-Last-Char is "A" ?
      jz     Make_aa_to 
      cmp    char2,'a'              ;Bef-Last-Char is "a" ?
      jz     Make_aa_be      
      jmp    Fin

;;                      

      Make_aa_to:
      mov    BH,To_aa
      jmp    Call_char            
      Make_aa_be:
      mov    BH,Be_aa
      jmp    Call_char            

;;                      

      Make_dd:
      cmp    char2,'D'              ;Bef-Last-Char is "D" ?
      jz     Make_dd_to      
      cmp    char2,'d'              ;Bef-Last-Char is "d" ?
      jz     Make_dd_be 
      jmp    Fin       

;;                      

      Make_dd_to:      
      mov    BH,To_dd
      jmp    Call_char            
      Make_dd_be:                   
      mov    BH,Be_dd
      jmp    Call_char

;;                      

      Make_ee:                      
      cmp    char2,'E'              ;Bef-Last-Char is "E" ?
      jz     Make_ee_to
      cmp    char2,'e'              ;Bef-Last-Char is "e" ?
      jz     Make_ee_be 
      jmp    Fin

;;                      

      Make_ee_to:
      mov    BH,To_ee
      jmp    Call_char
      Make_ee_be:
      mov    BH,Be_ee
      jmp    Call_char

;;                      

      Make_oo:
      cmp    char2,'O'              ;Bef-Last-Char is "O" ?
      jz     Make_oo_to
      cmp    char2,'o'              ;Bef-Last-Char is "o" ?
      jz     Make_oo_be 
      jmp    Fin                    ;No double case 

;;                      

      Make_oo_to:
      mov    BH,To_oo
      jmp    Call_char
      Make_oo_be:
      mov    BH,Be_oo
      jmp    Call_char

;; AW,OW,UW...      

      Make_w:
      cmp    AL,'W'                 ;Last Char is "W","w" ?
      jnz    Make_sign              ;If not, go to Make-sign routine 

;;                      

      cmp    char2,'A'              ;..Bef-Last-Char is "A" ?
      jz     Make_aw 
      cmp    char2,'a'              ;Bef-Last-Char is "a" ?
      jz     Make_aw_be
      cmp    char2,'O'              ;Bef-Last-Char is "O" ?
      jz     Make_ow
      cmp    char2,'o'              ;Bef-Last-Char is "o" ?
      jz     Make_ow_be
      cmp    char2,'U'              ;Bef-Last-Char is "U" ?
      jz     Make_uw
      cmp    char2,'u'              ;Bef-Last-Char is "u" ?
      jz     Make_uw_be
      jmp    Fin                    ;If not, then finish

;;                      

      Make_aw:
      mov    BH,To_aw
      jmp    Call_char
      Make_aw_be:
      mov    BH,Be_aw
      jmp    Call_char
      Make_ow:    
      mov    BH,To_ow
      jmp    Call_char
      Make_ow_be:
      mov    BH,Be_ow
      jmp    Call_char
      Make_uw:
      mov    BH,To_uw
      jmp    Call_char
      Make_uw_be:
      mov    BH,Be_uw

;;                      

      Call_char:
      call   Set_char
      jmp    Fin

;; Start to check Make-Sign case (af,as,ar,ax,aj,...)      

      Make_sign:             
      mov    Numskip,1
      cmp    AL,'F'                 ;..Last-Char is "F","f" ?
      jz     Done_sign
      inc    Numskip
      cmp    AL,'S'                 ;Last Char is "S","s" ?
      jz     Done_sign
      inc    Numskip
      cmp    AL,'R'                 ;Last Char is "R","r" ?
      jz     Done_sign
      inc    Numskip      
      cmp    AL,'X'                 ;Last Char is "X","x" ?
      jz     Done_sign
      inc    Numskip      
      cmp    AL,'J'                 ;Last Char is "J","j" ?
      jnz    Fin                    ;No sign found
      Done_sign:
      call   Put_sign      
      Fin:
      pop    CX
      pop    BX
      pop    AX
      pop    DI
      pop    ES
      ret
Fix_char ENDP

;;

Check_last PROC NEAR                ;Check last char. in
      cmp    AL,121                 ;"y"
      ja     Check_last_fin
      cmp    AL,65                  ;"A"
      jb     Check_last_fin
      clc
      ret
      Check_last_fin:
      stc
      ret                
Check_last ENDP                     ;Output CFlag, Char1/2/3/4

;;

Set_char PROC NEAR                  ;Set correct character into buffer
      mov    AH,5
      mov    CH,0Eh                 ;Scan code of <ESC>, ASCII code=8 
      mov    CL,8                   ;Back 1st, clear Last-Char
      int    16h                    ;..and put to buffer
      mov    AH,5                   ;Back once, very important!
      int    16h                    ;..and clear Bef-Last-Char also
      mov    AH,5
      xor    CH,CH
      mov    CL,BH                  ;Put new character in <BH> to buffer,
      int    16h                    ;..instead of Two old last characters
      ret
Set_char ENDP                       ;Input BH (Char.)

;;

Check_char PROC NEAR                ;Input: AL
      push   CS
      pop    ES
      mov    CX,Sp_char
      mov    DI,offset Char_set
      repnz  scasb                  ;Is the char. of (AL) special ??
      ret
Check_char ENDP                     ;Output: ZFlag (ZR,NZ)  

;;

Put_sign PROC NEAR                  ;Put sign to special character
      mov    AL,Char2               ;(2):Bef_Last, (3):Bef-Bef-Last, etc.
      call   Check_char
      jnz    Skip_cons              ;If (2) consonant or space...
      mov    AL,Char3               ;(2) vowel, then check (3) 
      call   Check_char
      jz     Skip_vowel             ;If (3) vowel...
      mov    AL,Char2               ;(3) cons or space, (2) vowel
      call   Sign_on
      ret

;;                      

      Skip_vowel:                   ;(3)&(2) vowels
      mov    AL,Char4
      and    AL,5Fh
      cmp    AL,'Q'                 ;Is (4) = "Q","q" ??
      jnz    Is_G
      mov    AL,Char2               ;"Qua","Quy"
      call   Sign_on
      ret

;;                      

      Is_G:                         
      cmp    AL,'G'                 ;Is (4) = "G","g" ??
      jnz    Lui_To_2
      mov    AL,Char3               
      and    AL,5Fh
      cmp    AL,'I'                 ;(4)="G", then (3)="I","i" ??
      jnz    Lui_To_2
      mov    AL,Char2               ;"Gia","Giu"
      call   Sign_on
      ret

;; 

      Lui_To_2:             
      mov    AH,5
      mov    CH,0Eh
      mov    CL,8                   ;Back 1 char.
      int    16h
      mov    AL,Char3               ;Put sign to (3)
      call   Sign_on
      mov    AH,5
      xor    CH,CH
      mov    CL,Char2               ;Restore (2)
      int    16h      
      ret

;;                      

      Skip_cons:                    ;(2) cons. or space
      cmp    Char2,65               ;(2) is not alfabet "A":"y" ?
      jb     Put_sign_fin
      cmp    Char2,121              ;(2) is cursor ?
      ja     Put_sign_fin
      ;;;
      mov    AL,Char3
      call   Check_char
      jnz    Lui_To_3               ;(3) cons. or space
      jmp    Lui_To_2               ;(3) vowel, (2) cons.

;;                      

      Lui_To_3:
      cmp    Char3,65              
      jb     Put_sign_fin
      cmp    Char3,121              
      ja     Put_sign_fin
      ;;;
      mov    AL,Char4               ;(3)&(2) consonants
      call   Check_char
      jnz    Put_sign_fin           ;(4) cons. or space
      mov    AH,5                   ;(4) vowel (3)&(2) cons. 
      mov    CH,0Eh         
      mov    CL,8                   ;Back 1 char.
      int    16h
      mov    AH,5
      int    16h                    ;Back 2 char.
      ;;;
      mov    AL,Char4               ;Put sign to (4)
      call   Sign_on
      ;;;
      mov    AH,5
      xor    CH,CH
      mov    CL,Char3               ;Restore (3)
      int    16h      
      mov    AH,5
      xor    CH,CH
      mov    CL,Char2               ;Restore (2)
      int    16h      

;;    

      Put_sign_fin:      
      ret
Put_sign ENDP                       ;Input [Char1/2/3/4] and BH 

;;

Sign_on PROC NEAR                   ;Put sign onto character
      cmp    AL,'A'
      jz     a_sign
      cmp    AL,'a'
      jz     a_sign

;;                      

      cmp    AL,'E'
      jz     e_sign
      cmp    AL,'e'
      jz     e_sign

;;                      

      cmp    AL,'I'
      jz     i_sign
      cmp    AL,'i'
      jz     i_sign

;;                      

      cmp    AL,'O'
      jz     o_sign         
      cmp    AL,'o'
      jz     o_sign         

;;                      

      cmp    AL,'U'
      jz     u_sign
      cmp    AL,'u'
      jz     u_sign

;;                      

      cmp    AL,'Y'
      jz     i_sign
      cmp    AL,'y'
      jz     i_sign

;;                      

      cmp    AL,To_aw   
      jz     aw_sign
      cmp    AL,Be_aw
      jz     aw_sign

;;                

      cmp    AL,To_aa   
      jz     aa_sign
      cmp    AL,Be_aa
      jz     aa_sign

;;                

      cmp    AL,To_ee   
      jz     ee_sign
      cmp    AL,Be_ee
      jz     ee_sign

;; 

      cmp    AL,To_oo   
      jz     oo_sign
      cmp    AL,Be_oo
      jz     oo_sign

;;                

      cmp    AL,To_ow   
      jz     ow_sign
      cmp    AL,Be_ow
      jz     ow_sign

;;                

      cmp    AL,To_uw   
      jz     uw_sign
      cmp    AL,Be_uw
      jz     uw_sign

;;                

      jmp    Get_fin                ;Not special character 

;;                

      a_sign:
      mov    BH,Be_a-1              ;For getting sign of Char(61hex)
      jmp    Get_sign
      e_sign:
      mov    BH,Be_e-1              ;For getting sign of Char(65hex)
      jmp    Get_sign
      i_sign:
      mov    BH,Be_i-1              ;For getting sign of Char(69hex)
      jmp    Get_sign
      o_sign:
      mov    BH,Be_o-1              ;For getting sign of Char(6Fhex)
      jmp    Get_sign
      u_sign:
      mov    BH,Be_u-1              ;For getting sign of Char(75hex)
      jmp    Get_sign

;;                

      aw_sign:
      mov    BH,Be_aw
      jmp    Get_sign
      aa_sign:
      mov    BH,Be_aa
      jmp    Get_sign
      ee_sign:
      mov    BH,Be_ee
      jmp    Get_sign
      oo_sign:
      mov    BH,Be_oo
      jmp    Get_sign
      ow_sign:
      mov    BH,Be_ow
      jmp    Get_sign
      uw_sign:
      mov    BH,Be_uw

;;                            

      Get_sign:
      add    BH,Numskip             ;For getting signs F/S/R/X/J
      call   Set_char
      Get_fin:
      ret
Sign_on ENDP

;;

Char1     DB ?                      ;Last characters in to buffer 
Char2     DB ?                      ;Before-last..
Char3     DB ?                      ;Before-Before-last..
Char4     DB ?                      ;Before-Before-Before-last..
Numskip   DB ?                      ;For getting VN sign [F/S/R/X/J]
Check_    DB '8542'                ;Parameter for checking residentness
Spare     DB 0                      ;For ending of parameter [Check_]
Char_set  DB 'AEIOUYaeiouy'
          DB Be_aw,Be_aa,Be_ee,Be_oo,Be_ow,Be_uw
          DB To_aw,To_aa,To_ee,To_oo,To_ow,To_uw   
Int9_ptr  EQU this dword            ;Equal 2 below values
Int9_ofs  DW 0                      ;For INT 9hex offset addr.
Int9_seg  DW 0                      ;For INT 9hex Segment addr.
Int17_ptr EQU this dword            
Int17_ofs DW 0                      ;For INT 17hex offset addr.
Int17_seg DW 0                      ;For INT 17hex Segment addr.
Recur     DB 0                      ;Checking variable in address
K_mask    DW 0003h                  ;<SHIFT+SHIFT>=0000000000000011 bin
Char_tab  DB 128,129,130,131,132
          DB 133,134,135,136,137,138
          DB 142,143,144,145,146,147

;;

          DB 148,149,150,151,152
          DB 153,154,155,156,157,158

;;

          DB 159,160,161,162,163

;;

          DB 164,165,166,167,168,169,170

;;

          DB 139,140,141 

;;

          DB 171,172,173,174,175
          DB 229,230,231,232,233,234
          DB 235,236,237,238,239,240

;;

          DB 241,242,243,244,245
          DB 246,247,248,249,250,251

;;

Char_num  EQU $-Char_tab

;; For printing unsigned cr

Char_into DB 'aaaaaaaaaaaaaaaaa'
          DB 'eeeeeeeeeee'
          DB 'iiiii'
          DB 'AADdEOO'
          DB 'UDZ'
          DB 'ooooooooooooooooo'
          DB 'uuuuuuuuuuu'

;;

All_left LABEL NEAR
Load_   DB 'VIETNAMESE KEYBOARD & SIMPLE PRINTER INITIALIZATION (C)'
        DB 10,13,'Toggle keyboard function with Shift+Shift',10,13,10,13
        DB 'Designed by Paul H'
Secret  EQU $-Char_into
        DB 'uang May`95',10,13,'$'
Unload_ DB 'Keyboard now unloaded',10,13,'$'
Errors_ DB 'Printer errors. Retry (Y/N)?',10,13,'$'

;;

Print_char PROC                     ;Input DL
      push   AX
      mov    AH,5
      int    21h
      pop    AX
      ret
Print_char ENDP

;;

Check_prn PROC                      ;Output CFlag
      push   AX
      push   DX
      Check_start:
      mov    AH,2
      xor    DX,DX                  ;Default PRN
      int    17h                    ;Check printer status
      cmp    AH,90h                 ;Ready status
      jnz    Printer_errors
      clc                           ;Ready!
      jmp    Check_prn_fin
      Printer_errors:
      lea    DX,Errors_
      mov    AH,9
      int    21h
      xor    AH,AH  
      int    16h
      and    AL,5Fh
      cmp    AL,'Y'
      jz     Check_start
      stc
      Check_prn_fin:
      pop    DX
      pop    AX
      ret
Check_prn ENDP

;;

Set_resident:                       ;Check if exists and make residentant
      mov    AX,3562h               ;Check residents
      int    21h                    ;[Check_]=[8542]
      mov    SI,offset check_
      mov    DI,BX                  ;BX outs from INT/21hex, Fn/35hex
      mov    CX,4                   ;4 chars
      repe   cmpsb                  ;Compare <SI>&<DI>, means <check_>&<BX>
      or     CX,CX                  ;CX=0 means <SI>&<DI> equal
      jnz    Install

;; Clear Memory            

      mov    AX,2562h               ;Put INT-Vector 62hex=0
      mov    DX,offset recur        ;Use RECUR for putting INT62=0000
      int    21h
      mov    DX,ES:int9_ofs         ;Restore INT/09 offset to DX     
      mov    AX,ES:int9_seg         ;Caution: Only [ES] can make!!
      mov    DS,AX                  ;Restore INT/09 segment to DS
      mov    AX,2509h               ;Restore INT/09
      int    21h
      mov    DX,ES:int17_ofs
      mov    AX,ES:int17_seg
      mov    DS,AX          
      mov    AX,2517h       
      int    21h
      mov    BX,ES                  ;Save Segment of our prog.
      mov    ES,ES:[2Ch]            ;Segment of Environment block in PSP
      mov    AH,49h
      int    21h                    ;Clear old Environment block
      mov    ES,BX
      mov    AH,49h
      int    21h                    ;Clear memory of our old prog.
      push   CS
      pop    DS                     ;For INT21hex [DS:DX]
      lea    DX,Unload_
      mov    AH,9
      int    21h

;;          

      call   Check_prn
      jc     Install_fin         ;Printer errors
      mov    DL,1Bh
      call   Print_char
      mov    DL,40h                 ;Initializes the printer
      call   Print_char      
      mov    DL,1Bh
      call   Print_char
      mov    DL,74h
      call   Print_char
      mov    DL,0                   ;Restore Italic Print Mode
      call   Print_char
      Install_fin:
      int    20h

;;                

Install:
      lea    DI,Char_into
      add    DI,Secret
      cmp byte ptr [DS:DI],'z'   
      jnz    Install_fin

;;                

      call   Check_prn
      jc     No_set_prn             ;Printer errors
      mov    DL,1Bh
      call   Print_char      
      mov    DL,74h
      call   Print_char
      mov    DL,1                   ;Set alternate printer mode 
      call   Print_char
      mov    DL,1Bh
      call   Print_char
      mov    DL,36h                 ;Set graphic printer mode
      call   Print_char

;;                

      No_set_prn:
      mov    AX,3509h               ;Save old INT/09
      int    21h                    ;Output BX,ES
      mov    CS:int9_ofs,BX
      mov    CS:int9_seg,ES
      mov    AX,3517h               ;Save old INT/17
      int    21h                    
      mov    CS:int17_ofs,BX
      mov    CS:int17_seg,ES

;;                

      mov    AX,2509h               ;Put new INT/09
      mov    DX,offset int9         ;New procedure for INT/09
      int    21h                    ;Input DX, no output
      mov    AX,2517h               ;Put new INT/17
      mov    DX,offset int17         
      int    21h                    
      mov    AX,2562h               ;Put INT-Vector 62hex=[Check_]
      mov    DX,offset check_
      int    21h

;;          

      mov    AH,9
      lea    DX,Load_
      int    21h
      mov    DX,offset All_left
      int    27h
codes ENDS
      END start
