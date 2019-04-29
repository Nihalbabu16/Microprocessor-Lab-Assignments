%macro println 2
	mov rax,01h
	mov rdi,01h
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .data
msg1 db 10,'Enter 4 digit Hex ::'
len1 equ $-msg1


msg2 db 10,'Eq BCd :: '
len2 equ $-msg2


section .bss
quo resb 1
accept resb 2
hex resb 2
remd resb 2

section .text
	global _start

_start:

	println msg1,len1

	call acceptNo
	mov [hex+1],bl		;accepting number in little endian format.
	
	call acceptNo
	mov [hex],bl
					;in hex to bcd we divide the numbers by 1000,100,10,1 and print the quotient ont the screen.

	println msg2,len2

	mov dx,0000h
	mov ax,[hex]
	mov bx,2710h		;dividing by 1000 we can also write mov bx,10000(to get first number 0)
	div bx
						;after division remainder gets in dx and quotient gets in al.
	mov [remd],dx

	add al,30h
	mov [quo],al
	println quo,01h		;since quotient can never be greater tha 9 so we dont need to check foe A,B,C,D,E,F so no need to compare with 39h and to add 07h even written will not executed, also since it is in the  second nibble so no need of and or shr.


	mov dx,0000h		;clearing dx for next operation's remainder.
	mov ax,[remd]
	mov bx,03e8h	

	div bx			;dividing by 1000
	mov [remd],dx

	add al,30h
	mov [quo],al
	println quo,01h


	mov dx,0000h
	mov ax,[remd]
	mov bx,0064h

	div bx			;dividing by 100
	mov [remd],dx

	add al,30h
	mov [quo],al
	println quo,01h


	mov dx,0000h
	mov ax,[remd]
	mov bx,000Ah

	div bx			;dividing by 10
	mov [remd],dx

	add al,30h
	mov [quo],al
	println quo,01h


	mov ax,[remd]
	add al,30h
	mov [quo],al
	println quo,01h


	mov rax,60
	syscall


acceptNo:

	mov rax,00h
	mov rdi,00h
	mov rsi,accept
	mov rdx,02h
	syscall

	mov al,[accept]
	sub al,30h
	cmp al,09h
	jle dontSub
	sub al,07h

dontSub:	
	mov cl,04h
	shl al,cl
	mov bl,al

	mov al,[accept+1]
	sub al,30h
	cmp al,09h
	jle dontSubb
	sub al,07h

dontSubb:
	or bl,al
ret
