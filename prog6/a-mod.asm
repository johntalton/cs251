;John Talton
;cs251 Prog6
.model small
.stack 100h
.data
      Prompt  db  "Enter an expression: ",'$'
      numbuff db  80 dup(?)
      strptr  dw  ?
      fpval   dd  0.0
      result  dd  0.0
.code
extrn _FindNum:proc
extrn _MoveNum:proc
extrn _ConvertNum:proc
extrn _PrintNum:proc
extrn _GetEQ:proc
public _main
_main proc
     mov   ax,  @data
     mov   ds,  ax

  newequ:
     ;--------Get infix EQ---------
     mov   ax, offset Prompt
     push  ax
     call  _GetEQ
     pop   dx
     add   ax,2
     ;-----------------------------
     mov   strptr,ax
     ;-------Convert ot post-------
     ;  Will add that in later
     ;-----------------------------
    ; mainloop:
     mov si, strptr
     cmp byte PTR [si], 'q'
     je  bye

     ;inc strptr

     ;mov si, strptr
     ;cmp byte PTR [si], 0dh
     ;jne mainloop

     mov ah, 2
     mov dl, '='
     int 21h
     mov ah, 2
     mov dl, '>'
     int 21h


     jmp FAR PTR newequ
     bye:



     mov   ax, 4c00h           ;normal proc term signal
     int   21h
_main endp
end _main

