
;

.model small
.stack 100h


.data

number	dd	2.123

.code
extrn _PrintNum:proc
public _main
;main 	proc
;
;	call _main
;main	endp
_main	proc
	mov	ax, @data
	mov	ds, ax
	mov	ax, word ptr number+2
	push 	ax
	mov	ax, word ptr number
	push	ax
	call	_PrintNum
	pop 	ax
	pop	ax
	mov	ah, 4ch
	int	21h

_main 	endp
end	_main