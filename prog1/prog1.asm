;John Talton
;prog1.asm
;cs251



.model  small
.stack  100h

.data
   byteArray  db -10, -15, -20, -25, -30
   byteSum    db ?
   wordArray  dw 5 dup (?)
   wordSum    dw ?
.code
main proc
     mov     ax, @data
     mov     ds, ax
     
     mov     ax,0
     mov     cx, 5
     mov     byteSum,0
     mov     di, 0    
     mov     di, offset byteArray

  l1:mov     al, [di]
     add     al, byteSum
     mov     byteSum,al
     add     di,1
     loop    l1

     mov     di, offset wordArray
     mov     si, offset byteArray  
     mov     cx, 5
  l2:mov     al, [si]
     cbw
     mov     [di], ax
     add     si, 1
     add     di, 2
     loop    l2
     
     mov     di, offset wordArray
     mov     cx, 5
  l3:mov     ax, [di]
     add     ax, wordSum
     mov     wordSum,ax
     add     di,2
     loop    l3
   
     mov     ax, 4c00h
     int     21h
main endp
end  main