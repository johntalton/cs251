;John Talton   prog4.asm    cs251
;This program is a example of the int 33h mouse function and
;convertion from pixels to ASCII charicters.
.model  small
.stack  100h
.data
Mystr   db 'X = 00  Y = 00','$'
.code
MyColor EQU  00100111b
;Function that prints a char at a particular X Y location stord in
;  al  ==  ASCII
;  dh  ==  Y
;  dl  ==  X
pchr proc
     push    bx
     push    cx
     push    si
     mov     si,   ax
     push    ax
     mov     ax,   si
     mov     ah,   2       ;Jump to the localtion in dh,dl
     mov     bh,   0
     int     10h
     mov     ah,   0ah     ;Print the char [al] in MyColor
     mov     bh,   0
     mov     bl,   MyColor
     mov     cx,   1
     int     10h
     pop     ax
     pop     si
     pop     cx
     pop     bx
     ret
pchr endp
;Conv - converts a pixel number to ASCII code
; and calls the print char proc
conv proc
     push    ax
     push    bx
     push    di
     mov     di,   dx
     shr     cx,   3    ;Div the pixel num by 8
     shr     di,   3
     mov     bh,   10   ;Divid by 10 to get tens digit
     mov     ax,   cx
     div     bh
     add     al,   30h  ;Add 30h to get corect ASCII code
     add     ah,   30h
     mov     dh,   12   ;print tens digit of X
     mov     dl,   37
     call    pchr
     mov     al,   ah   ;print ones digit of X
     mov     dh,   12
     mov     dl,   38
     call    pchr
     mov     bh,   10
     mov     ax,   di
     div     bh
     add     al,   30h
     add     ah,   30h
     mov     dh,   12   ;print tens digit of Y
     mov     dl,   45
     call    pchr
     mov     al,   ah   ;print ones digit of Y
     mov     dh,   12
     mov     dl,   46
     call    pchr
     pop     dx
     pop     bx
     pop     ax
     ret
conv endp
;Main proc dose all init of vidio and such
main proc
     mov     ax,   @data
     mov     ds,   ax
     mov     ah,   0fh  ;Get curent Video Page and Mode
     int     10h
     push    ax
     push    bx
     mov     ah,   0    ;Set to color mode
     mov     al,   3
     int     10h
     mov     ah,   5    ;Set to page 0 because that is what mouse uses
     mov     al,   0
     int     10h
     mov     ah,   2    ;Set Cursor position to 0,0
     mov     bh,   0
     mov     dh,   0
     mov     dl,   0
     int     10h
     mov     ah,   9    ;Pirnt out blank spaces to clear screen
     mov     al,   ' '
     mov     bh,   0
     mov     bl,   MyColor
     mov     cx,   2000
     int     10h
     mov     ax,   00h  ;Start mouze
     int     33h
     cmp     ax,   00h  ;if mouze not there end
     je      exit
     mov     ax,   1
     int     33h        ;turn on mouse cursor
     mov     ah,   2    ;Move so we can write out the string
     mov     bh,   0    ; center of screen
     mov     dh,   12
     mov     dl,   33
     int     10h
     mov     dx,   offset Mystr
     mov     ah,   9
     int     21h
     mov     ah,   1    ;Hide text cursor
     mov     cl,  -1
     mov     ch,  -1
     int     10h
;--------=========Main Loop=========--------
     begin:
     mov     ax,   3    ;Get button status
     int     33h
     call    conv       ;Function to print ASCII num
     mov     ax,   5    ;Get mouse button press info
     mov     bx,   1    ; bx = 1 is right button pointer
     int     33h
     cmp     ax,   1
     jne     begin      ;Checks to see if the left mouse button was
                        ; presses and if so exit the loop
;--------=========End  Loop=========--------
     mov     ax,   2    ;Kill mouse
     int     33h
     exit:
     pop     bx
     pop     ax
     mov     ah,   0
     int     10h        ;Set back to original Video Mode
     mov     ah,   5
     mov     al,   bl
     int     10h        ;Set back to original Videw Page
     mov     ax, 4c00h  ;Get out of here and returen to OS
     int     21h
main endp
end  main

