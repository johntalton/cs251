;John Talton   prog4.asm    cs251

.model  small
.stack  100h
.data

OurPage db ?

.code

main proc
     mov     ax,   @data
     mov     ds,   ax

     mov     ah,   0fh  ;This section fo code finds the curent
     int     10h        ; vidio page and sets to the next page
     push    bx         ; (ex: we our on page 2 it sets us to page
     add     bh,   1    ; 3, it we are on 3 it sets us to 1)  By
     cmp     bh,   3    ; doing this we can preserve all text and 
     je      setto1     ; text atributs of the original page.
     jmp     skipover
     setto1:
     mov     bh,   1
     skipover:
     mov     byte PTR OurPage, bh
     mov     ah,   5
     mov     al,   OurPage
     int     10h
 
     mov     ah,   2       ;Here we set the cursor positon to the top
     mov     bh,   OurPage ; left cornter so we can clear the screen
     mov     dh,   0
     mov     dl,   0
     int     10h   
     mov     ah,   9       ;This Clears the screen and sets it to a color
     mov     al,   ' '     ; of our choice
     mov     bh,   OurPage
     mov     bl,   00100000b
     mov     cx,   word PTR 2000
     int     10h   

     mov     ah,1
     int     21h


     pop     bx          ;Get out of our page and set
     mov     ah, 5       ; it back to the users original
     mov     al, bh      ; page.
     int     10h 
     mov     ax, 4c00h   ;Get out of here and returen to OS
     int     21h
main endp
end  main
     