;John Talton   prog3.asm    cs251


.model  small
.stack  100h
.data



.code





main proc
     mov     ax, @data
     mov     ds, ax

     mov    ah,2
     mov   dl, 'f'
     int   21h

    
     mov     ah,9
     mov     al,' '
     mov     bh, 0
     mov     bl, 01000000b
     mov     cx,3200
     int     10h

     mov     ah,1
     int     21h

     mov     ax, 4c00h
     int     21h
main endp
end  main
     