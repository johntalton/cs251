;John Talton
;CS251
;Jan 98
;Plays with strings - revers Uper&Lower case
.model small
.stack 100h
.data
     Menu     db 'E......Enter a new string',0dh,0ah
              db 'R......Reverse the string',0dh,0ah
              db 'U...Convert to upper case',0dh,0ah
              db 'L...Convert to lower case',0dh,0ah
              db 'Q............Exit program',0dh,0ah,0dh,0ah,00h
   ThePrompt  db 'Enter your command:  ',00h   ;Enter a command
   StrPrompt  db 'Enter a string:  ',00h
   TheCommand db ?
   SourceStr  db 80,81 dup(0)
   DestStr    db 80 dup(0), 00h
   Return     db 0dh,0ah, 00h
   NoStrMes   db 'Error: no valid string available',0dh,0ah,00h
.code
doMenu proc                  ;proc to print out string ending in NULL(00h)
       push  ax
       mov   si, dx
       push  dx
       mov   ah, 2
    l1:mov   dx, [si]
       int   21h
       inc   si
       cmp   byte PTR [si], 00h
       jne   l1
       pop   dx
       pop   ax
       ret
doMenu endp
getCmd proc                ;Gets a single char fron standerd input
       push  ax
       mov   ah, 1
       int   21h
       mov   TheCommand, al
       mov   ah, 2
       mov   dl, 0dh
       int   21h
       mov   dl, 0ah
       int   21h
       pop   ax
       ret
getCmd endp
getStr proc               ;Gets a string of 80 char using a keybord buf
       push  ax
       mov   ax, dx
       mov   dx, offset StrPrompt
       call  doMenu
       mov   dx, ax
       mov   ah, 0ah
       int   21h
       pop   ax
       ret
getStr endp
RevStr proc
       push ax
       push di
       push si
       mov  si, dx              ;copys offset of str to rev to si
       inc  si                  ;mov to index of str buf
       cmp  byte PTR [si],0     ;test to see if the str is empty
       je   noStr0
       mov  al, byte PTR [si]   ;mov the num of char in str to al
       cbw                      ;convert byte 2 word al -> ax
       mov  cx,ax               ;cx is loop counter
       inc  si                  ;mov to first char in str source
       mov  di, offset DestStr  ;output rev str to DestStr in mem
       add  di, cx              ;mov to end pos in the DestStr
       mov  byte PTR [di], 00h  ;put sentnal NULL for PrtStr proc
       sub  di,1                ;dec DestStr on space
       rev:
       mov  al, [si]            ;mov char from source to dest
       mov  [di], al            ;  through reg al
       inc  si                  ;mov forward in source
       sub  di,1                ;mov backward in dest
       loop rev                 ;log for cx (num of chars)
       mov  dx, offset DestStr  ;set dx to begining of DestStr
       call doMenu              ;print dest str
       mov  dx, offset Return   ;Print return
       call doMenu
       jmp  skipover0           ;skip over error mess
       noStr0:
       mov  dx, offset NoStrMes ;print out if no str
       call doMenu
       skipover0:
       pop  si
       pop  di
       pop  ax
       ret
RevStr endp
Up_Str proc
       push  ax
       push  si
       push  di
       mov   si, dx
       push  dx
       push  cx
       inc   si
       cmp   byte PTR [si],0
       je    noStr1
       mov   di, offset DestStr
       inc   si
       mainup:
       cmp   byte PTR [si],96     ;check if lower that 'a'
       jbe   notlower
       cmp   byte PTR [si],122    ;check if greater that 'z'
       jae   notlower
       mov   al, byte PTR [si]    ;mov to DestStr
       mov   byte PTR [di], al
       sub   byte PTR [di],32     ;conver to upercase
       jmp   skip
       notlower:
       mov   al, byte PTR [si]    ;no a lower case leter
       mov   byte PTR [di], al    ;  so just move to dest
       skip:
       inc   di                   ;inc both
       inc   si
       cmp   byte PTR [si], 0dh   ;if end of Source then exit
       jne   mainup
       mov   byte PTR [di], 00h   ;add NULL to end of destStr
       mov  dx, offset DestStr
       call doMenu
       mov  dx, offset Return
       call doMenu
       jmp  skipover
       noStr1:
       mov  dx, offset NoStrMes
       call doMenu
       skipover:
       pop  cx
       pop  dx
       pop  di
       pop  si
       pop  ax
       ret
Up_Str endp
LowStr proc
       push  ax
       push  si
       push  di
       mov   si, dx
       push  dx
       push  cx
       inc   si
       cmp   byte PTR [si],0
       je    noStr2
       mov   di, offset DestStr
       inc   si
       mainlow:
       cmp   byte PTR [si],64    ;check lower than 'A'
       jbe   notup
       cmp   byte PTR [si],91    ;check greater than 'Z'
       jae   notup
       mov   al, byte PTR [si]   ;mov to dest
       mov   byte PTR [di], al
       add   byte PTR [di],32    ;make lowercase
       jmp   skipx
       notup:
       mov   al, byte PTR [si]   ;just mov
       mov   byte PTR [di], al
       skipx:
       inc   di
       inc   si
       cmp   byte PTR [si], 0dh
       jne   mainlow
       mov  byte PTR [di], 00h    ;add NULL for prtStr proc
       mov  dx, offset DestStr
       call doMenu
       mov  dx, offset Return
       call doMenu
       jmp  skipover1
       noStr2:
       mov  dx, offset NoStrMes
       call doMenu
       skipover1:
       pop  cx
       pop  dx
       pop  di
       pop  si
       pop  ax
       ret
LowStr endp
main proc
     mov   ax,  @data
     mov   ds,  ax
     mov   dx, offset Menu
     call  doMenu
     mainloop:
     mov   dx, offset ThePrompt
     call  doMenu
     call  getCmd                 ;Get command and check to see
     cmp   TheCommand, 'U'        ;  if it is ULER else just
     je    doU                    ;  keep looping till Q
     cmp   TheCommand, 'L'
     je    doL
     cmp   TheCommand, 'E'
     je    doE
     cmp   TheCommand, 'R'
     je    doR
     cmp   TheCommand, 'Q'
     je    mainend
     jmp   mainloop
     doU:
     mov    dx, offset SourceStr  ;U callback
     call   Up_Str
     jmp   mainloop
     doL:
     mov    dx, offset SourceStr  ;L callback
     call   LowStr
     jmp   mainloop
     doE:
     mov   dx, offset SourceStr   ;E callback
     call  getStr
     mov   dx, offset Return
     call  doMenu
     jmp   mainloop
     doR:
     mov    dx, offset SourceStr  ;R callback
     call   RevStr
     jmp   mainloop
     mainend:
     mov   ax, 4c00h           ;normal proc term signal
     int   21h
main endp
end main
