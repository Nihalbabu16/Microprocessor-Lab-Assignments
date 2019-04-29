global acceptstr,occurence,strlen,strlines 
extern str1,len1,msg1,lenstr1,msg2,len2
extern  msg3,len3,msg4,len4,character


%macro println 2
	mov rax,01h
	mov rdi,01h
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro


section .data


section .bss
display resb 2
section .text

acceptstr:

	println msg1,len1
	
	mov rax,00h
	mov rdi,00h
	mov rsi,str1
	mov rdx,15
	syscall
	dec al
	mov [lenstr1],al
ret

strlen:
	println msg2,len2

	mov bl,[lenstr1]
	call displayNo
ret


occurence:
	println msg3,len3

	mov rax,00h
	mov rdi,00h
	mov rsi,character
	mov rdx,02h
	syscall

	println msg4,len4

	mov cl,[lenstr1]
	mov rsi,str1
	mov bl,00h		; occurence count

	mov al,byte[character]
chkNext:	
	cmp al,[rsi]
	jne skip
	inc bl
skip:
	inc rsi
	dec cl
	jnz chkNext

	call displayNo
ret
strlines:
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

