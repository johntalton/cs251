.model  small
.stack  100h
.code
main proc
     mov     ax,   @data
     mov     ds,   ax
   
     mov     ah, 0
     mov     al, 2
     int 10h

     mov     ah,5
     mov     al, 4
     int     10h         ;Set to page 0 because that is what mouse uses
  

     mov     ax, 4c00h   ;Get out of here and returen to OS
     int     21h
main endp
end  main
     