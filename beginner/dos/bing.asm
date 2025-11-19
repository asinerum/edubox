; os_play_sound -- Play a single tone using the pc speaker
; IN: CX = tone frequency (higher value = lower frequency), BX = duration (arbitrary units)

section .text
global os_play_sound

os_play_sound:
    ; Set PIT channel 2 to square wave mode
    mov al, 182         ; 10110110b: Channel 2, LSB/MSB, Mode 3 (Square Wave), Binary counter
    out 0x43, al        ; Control word to PIT command port

    ; Set the frequency divisor for channel 2
    mov ax, cx          ; CX holds the frequency divisor
    out 0x42, al        ; Output LSB of divisor to PIT channel 2 data port
    mov al, ah          ; Move MSB of divisor to AL
    out 0x42, al        ; Output MSB of divisor to PIT channel 2 data port

    ; Turn on speaker
    in al, 0x61         ; Read current state of PPI port B
    or al, 00000011b    ; Set bits 0 and 1 (enable timer 2 output and speaker)
    out 0x61, al        ; Write back to PPI port B

    ; Delay loop for duration
.pause1:
    mov cx, 65535       ; Inner loop counter for delay
.pause2:
    dec cx
    jne .pause2
    dec bx              ; Decrement duration counter
    jne .pause1

    ; Turn off speaker
    in al, 0x61         ; Read current state of PPI port B
    and al, 11111100b   ; Clear bits 0 and 1 (disable timer 2 output and speaker)
    out 0x61, al        ; Write back to PPI port B

    ret
