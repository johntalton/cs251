;John Talton
;cs251
;This is the imput function for prog6
;it takes in 2 pointers to buffers and
;returns a ponter to a string in ax
.model small
.code
public _GetEQ
_GetEQ proc
     push bp
     mov  bp,sp

     mov   ah, 2
     mov   dl,0ah
     int   21h
     mov   ah, 2
     mov   dl, 0dh
     int   21h

     mov   ah, 9
     mov   dx, [bp + 6]
     int   21h
     mov   dx, [bp + 4]
     mov   ah, 0Ah
     int   21h
     mov   ah, 2
     mov   dl,0ah
     int   21h
     mov   ah, 2
     mov   dl, 0dh
     int   21h
     mov   ax, [bp + 4]
     inc   ax             ;inc 2 time because it used a
     inc   ax             ; string buffer and we dont
                          ; need the first two values
     pop bp
     ret
_GetEQ endp
end


