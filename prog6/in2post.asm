;John Talton
;cs251
;prog5
;This program takes a Infix expretion with no errors
;and converts it to a Postfix notation
.model small
.stack 500h
.data
   Infix    db   80,81 dup(?)
   Prompt   db   "Enter an exprossion: ",'$'
.code
Post proc
     push  bp
     mov   bp,sp
     mov   si, [bp + 4]
     push  bx
     push  ax
     mov   al, 00h
     mov   ah, 00h
     push  ax
   Mainloop:
     cmp   byte PTR [si],0dh
     je    waywayoutlong
     cmp   byte PTR [si], ')'   ;What to do with char
     je    waywayoutlong
     cmp   byte PTR [si], '('
     je    prth
     cmp   byte PTR [si], '+'
     je    doop
     cmp   byte PTR [si], '-'
     je    doop
     cmp   byte PTR [si], '*'
     je    doop
     cmp   byte PTR [si], '/'
     jne   prtnum
   doop:
     mov   dl, ' '
     mov   ah, 2       ;print prity space
     int   21h
     cmp   byte PTR [si], '+'    ;fig out precidence
     je    pres1
     cmp   byte PTR [si], '-'
     je    pres1
     cmp   byte PTR [si], '*'
     je    pres2
     cmp   byte PTR [si], '/'
     je    pres2
   pres1:
     mov   ah,1
     jmp   overpres
   pres2:
     mov   ah,2
   overpres:
     mov   al,[si]
   domore:
     pop   bx         ;hols tmp
     cmp   ah,00h
     je    wayout
     cmp   ah,bh
     je    poptill    ;cmp precidence level
     push  bx
     push  ax
     jmp   goaround
   waywayoutlong:
     jmp   waywayout
   poptill:
     push  ax
     mov   dl,bl
     mov   ah, 2
     int   21h
     pop   ax
     jmp   domore
   goaround:
     jmp   getout
   prtnum:            ;Just print it out
     mov   ah, 2
     mov   dl, byte PTR [si]
     int   21h
     jmp   getout
   prth:
     inc   si
     push  si
     call  Post    ;handle ( in here via recution
     mov   si, di  ;Passes si updated position
     jmp   Mainloop
   getout:
     inc   si
     cmp   byte PTR [si], 0Dh
     jne   Mainloop
   wayout:
     inc   si
     pop   ax
   poptillend:   ;pop the stack untill 00h is reached
     mov   dl,al
     mov   ah, 2
     int   21h
     pop   ax
     cmp   al,00h
     jne   poptillend
     jmp   around
   waywayout:
     pop   ax
     cmp   al,00h  ;check for any ops in the stack
     je    around
     jmp   poptillend
   around:
     mov   di, si
     pop   ax
     pop   bx
     pop   bp
     ret   2    ;return 2 - one peram
Post endp
;Main proc just inputs a string an passes it to the
;Post proc
main proc
     mov   ax,  @data
     mov   ds,  ax
   DoNext:
     mov   ah, 2
     mov   dl,0ah
     int   21h
     mov   ah, 2
     mov   dl, 0dh
     int   21h
     mov   ah, 9
     mov   dx, offset Prompt
     int   21h
     mov   dx, offset Infix
     mov   ah, 0Ah
     int   21h
     mov   ah, 2
     mov   dl,0ah
     int   21h
     mov   ah, 2
     mov   dl, 0dh
     int   21h
     mov   si, offset Infix
     inc   si
     inc   si
     cmp   byte PTR [si], 'q'
     je    endprogy
     push  si
     call  Post
     jmp   DoNext
   endprogy:
     mov   ax, 4c00h           ;normal proc term signal
     int   21h
main endp
end main
