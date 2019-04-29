
%macro println 2
	mov rax,01h
	mov rdi,01h
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .data
msg1 db 10,'Enter Number for factorial Calculation : '
len1 equ $-msg1

msg2 db 10,'Factorial of Number is : '
len2 equ $-msg2

fact0 db 10,'Factorial of 0 is :: 1'
factlen equ $-fact0


section .bss
display resb 2
accept resb 3	
number resb 1
result resb 8


section .text
	global _start
_start:

	println msg1,len1

	call acceptNo
	mov [number],bl

	cmp bl,00h 		;comparing entered value with 0 .
	jne goAhead
	println fact0,factlen
	jmp exit

goAhead:
	println msg2,len2

	mov bl,[number]

	call fact

	mov [result],rax		;moving content of rax to variable result for transfering this value to register bl for displaying.

	mov rsi,result+7			;little endian
	mov rcx,08h

dispNext:
	mov bl,[rsi]
	push rcx
	push rsi
	call displayNo
	pop rsi
	pop rcx
	dec rsi
	dec rcx
	jnz dispNext		;displaying the output.

exit:
	mov rax,60
	syscall


fact:
	cmp bl,01h			;checking whether the value has become 1 or not.
	jne doStack	
	mov ax,01h			;moving 1 in rax.
ret

doStack:
	push rbx		;first all the values are put on stack untill the value becomes 1.
	dec bl
	call fact
	pop rbx			;poping all the values recursively.
	mul rbx			;multiplying the poped value to rax first we have put 1 i.e 01h in rax and now multiplying by(rbx as the number is bigger) recursively.
ret


acceptNo:

	mov rax,00h
	mov rdi,00h
	mov rsi,accept
	mov rdx,03h
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

displayNo:

	mov al,bl
	and al,0f0h
	mov cl,04h
	shr al,cl
	add al,30h
	cmp al,39h
	jle dontAdd
	add al,07h

dontAdd:
	mov [display],al

	mov al,bl
	and al,0fh
	add al,30h
	cmp al,39h
	jle dontAddd
	add al,07h

dontAddd:
	mov [display+1],al

	println display,02h

ret


