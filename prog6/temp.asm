;John Talton
;cs251
.model small
.stack 100h
extrn _FindNum:proc
extrn _MoveNum:proc
extrn _ConvertNum:proc
extrn _PrintNum:proc
extrn _GetEQ:proc
public _main
.data
    Prompt  db  "Enter an expression: ",'$'
    string  db  80,?,80 dup(?)
    numbuff db  80 dup(?)
    strptr  dw  ?
    fpval   dd  0.0
    result  dd  0.0
.code

_main proc
     mov   ax,  @data
     mov   ds,  ax
   DoNext:
     ;-------Get input-----
     push offset Prompt
     push offset string
     call _GetEQ
     pop  dx
     pop  dx
     ;-----Return in ax-----
     ;--Convert to postfix--
     ; I will do that later
     ; my in2post function (prog5)
     ; does not work so we will
     ; assume that the user inputed
     ; the equ in postfix
     ;----------------------

     mov  si, ax
     cmp   byte PTR [si], 'q'
     je    endprogy



;     call  workfunc




     jmp   DoNext
   endprogy:
     mov   ax, 4c00h           ;normal proc term signal
     int   21h
_main endp
end _main
