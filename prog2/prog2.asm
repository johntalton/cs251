;John Talton    cs251
;prog2.asm
.model small
.stack 100h
.data
     aMatrix    dw  1,  2,  3,  4
                dw  5,  6,  7,  8 
                dw  9,  10, 11, 12
                dw  13, 14, 15, 16
     aTrans     dw  16 dup(?)
.code
     DataSize   EQU 2  ;Size of elements in matrix -word-
     MatrixSize EQU 4  ;Size of Matrix
     RowLength  EQU 8  ;Length of Row in bytes = DataSize * MatrixSize
     RowOffset  EQU 32 ;MatrixSize * RowLength
main proc
     mov        ax, @data
     mov        ds, ax
     mov        cx, MatrixSize
     mov        si, 0
     mov        di, 0
  l1:push       cx
     mov        cx, MatrixSize
  l2:mov        dx, aMatrix[di]
     mov        aTrans[si], dx
     add        si, DataSize
     add        di, RowLength  
     loop       l2
     pop        cx
     sub        di,RowOffset
     add        di,DataSize
     loop       l1
     mov        ax, 4c00h
     int        21h
main endp
end  main