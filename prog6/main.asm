;John Talton
;cs251 Prog6
.model small
.stack 100h
.data
      Prompt  db  'Enter an expression: ','$'
      strptr  dw  ?
      numbuff db  80,?,80 dup(?)
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
     ;mov   bx, offset Prompt
     push  offset Prompt
     call  _GetEQ
     pop   dx
     add   ax,2
     ;-----------------------------
     mov   strptr,ax
     ;-------Convert ot post-------
     ;  Will add that in later
     ;-----------------------------
mainloop:
     mov   si, strptr
     cmp   byte PTR [si], '+'
     je    dosignx
     cmp   byte PTR [si], '-'
     je    dosignx
     cmp   byte PTR [si], '*'
     je    dosignx
     cmp   byte PTR [si], '/'
     je    dosignx
     cmp   byte PTR [si], 'q'
     je    byex
     ;FindNum    (char**);
     push offset strptr
     call _FindNum
     pop  dx
     cmp  ax, 1
     jne  around
     ;MoveNum  (char*, char**);
     push offset strptr
     push offset numbuff
     call _MoveNum
	  pop  dx
	  pop  dx
	  ;ConvertNum (char*, float*);
	  push offset fpval
	  push offset numbuff
	  call _ConvertNum
	  pop  dx
	  pop  dx

	  jmp temp
   dosignx:
     jmp dosign
  temp:

	  ;PrintNum (fpVal);
     push fpval
     call _PrintNum
     pop  dx

     fld fpval
     fwait
     ;jmp  over
     jmp dosign


   byex:
     jmp bye
     ;it is a float num so push it to st(0)
  around:

  dosign:
     mov   si, strptr
     cmp   byte PTR [si], ' '
     je    space
     cmp   byte PTR [si], '+'
     je    doadd
     cmp   byte PTR [si], '-'
     je    dosub
     cmp   byte PTR [si], '*'
     je    domul
     cmp   byte PTR [si], '/'
     je    dodiv

     ;mov  ah, 2
     ;mov  dx, [si]
     ;int  21h

     jmp outter

   bye:
     jmp byebye
   mainloopx:
     jmp  mainloop

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
   space:
     add strptr, -1
   outter:
     ;it is a sign do the apropreat thingy
     add strptr,2
  over:
     cmp byte PTR [strptr], 0dh
     jne mainloopx

     mov ah, 2
     mov dl, '='
     int 21h
     mov ah, 2
     mov dl, '>'
     int 21h

     fst result
     fwait
     push result
     call _PrintNum
     pop  dx

     jmp FAR PTR newequ

  byebye:



     mov   ax, 4c00h           ;normal proc term signal
     int   21h
_main endp
end _main

