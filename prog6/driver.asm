;John Talton
;cs251
;Ok this is like the heart of prog6
; it calles all the C functions and does
; the work.  it should actually be split
; into 2 files and all
;
;Technacal stuff
; due to the fact that my prog5 did not work
; the expretions must be enterd in POST fix
; notation.  As soon as I fix prog5 I will
; add that in.
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
     mov  ax,offset Prompt
     push ax
     mov  ax, offset string
     push ax
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
     mov  strptr,ax
     ;---------------------
     mov  si,strptr
     cmp   byte PTR [si], 'q'
     je    endprogyx

;===================================================
mainloop:
     mov   si, strptr
     cmp   byte PTR [si], ' '
     je    outterx
     cmp   byte PTR [si], '+'
     je    doaddx
     cmp   byte PTR [si], '-'
     je    dosubx
     cmp   byte PTR [si], '*'
     je    domulx
     cmp   byte PTR [si], '/'
     je    dodivx
     ;FindNum    (char**);
     push offset strptr
     call _FindNum
     pop  dx
     ;cmp  ax, 1
     ;jne  around
     ;MoveNum  (char*, char**);
     ;   moves a num into numbuff
     push offset strptr
     push offset numbuff
     call _MoveNum
	  pop  dx
	  pop  dx
	  ;ConvertNum (char*, float*);
	  ;   converts num to a floatingpoint val
	  push offset fpval
	  push offset numbuff
	  call _ConvertNum
	  pop  dx
	  pop  dx
	  ;PrintNum (fpVal);
	  ;  what you think it does its a print function
     push fpval
     call _PrintNum
     pop  dx
     fld fpval
     fwait
     jmp over   ; This is a small jmp table because
  endprogyx:    ;  most of the jmps are too long for
     jmp endprogy  ;assembley to go that far
  mainloopx:
     jmp mainloop
  doaddx:
     jmp doadd
  dosubx:
     jmp dosub
  domulx:
     jmp domul
  dodivx:
     jmp dodiv
  outterx:
     jmp outter
  ; around:
    ; jmp outter
     doadd:
       mov ah, 2
       mov dl, '+'
       int 21h
       fadd
       fwait
       jmp outter
     dosub:
       mov ah, 2
       mov dl, '-'
       int 21h
       fsub
       fwait
       jmp outter
     domul:
       mov ah, 2
       mov dl, '*'
       int 21h
       fmul
       fwait
       jmp outter
     dodiv:
       mov ah, 2
       mov dl, '/'
       int 21h
       fdiv
       fwait
       jmp outter
     outter:
       add strptr,1
     over:
     mov si,strptr
     cmp byte PTR [si], 0dh ;check are we at the end yet
     jne mainloopx

     mov ah, 2      ; print out some nice looking stuff
     mov dl, '='
     int 21h
     mov ah, 2
     mov dl, '>'
     int 21h

     fst result    ; get the result and print it
     fwait
     push result
     call _PrintNum
     pop  dx
;==========================================
     jmp DoNext
   byebye:
   endprogy:
     mov   ax, 4c00h           ;normal proc term signal
     int   21h
_main endp
end _main
