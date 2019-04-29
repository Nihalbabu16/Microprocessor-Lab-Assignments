%macro println 2
	mov rax,01h
	mov rdi,01h
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .data
;array db 55h,44h,33h,22h,11h

space db '  '

filename db 'abc.txt',00h

msg1 db 10,'Array is :',10
len1 equ $-msg1

msg2 db 10,'Sorted Array is :',10
len2 equ $-msg2


section .bss
array resb 15
handle resb 8
display resb 2
accept resb 2
filelength resb 8
buffer resb 50

section .text
	global _start

_start:

	mov rax,02h		;function to open the file
	mov rdi,filename	;filename specifed above.
	mov rsi,02h			;only file will be opened ,it will not get created,
	mov rdx,0777o		;giving the permissions.
	syscall

	mov [handle],rax	;rax returns the size ,total length here it returns  a number inplace of nameoffile operations will be done by using this number.


	mov rax,00h 		;code of write function.
	mov rdi,[handle]	;special number given by the system is use in place of file name.
	mov rsi,buffer		;variable name.
	mov rdx,50h			;size of variable.
	syscall

	mov [filelength],rax		;storing the min(file_length ,buffer_size).


	mov cl,05h
	mov rdi,array
	mov rsi,buffer
nextElement:
	mov al,[rsi]
	mov [accept],al
	inc rsi
	mov al,[rsi]
	mov [accept+1],al		;putting the file content in vaiable accept one by one.

	push rsi
	push rcx
	call acceptNo		;passing value of accept to acceptNo for conversion.
	pop rcx
	pop rsi

	mov [rdi],bl
	inc rsi
	inc rsi			;inc rsi twice to skip thw blankspace.
	inc rdi
	dec cl
	jnz nextElement
					;all values of file have been stored in array.

	println msg1,len1	

	mov cl,05
	mov rsi,array

dispNext:	
	mov bl,[rsi]
	push rcx
	push rsi

	call displayNo
	println display,02h
	println space,02h

	pop rsi
	pop rcx
	inc rsi
	dec cl
	jnz dispNext
					;displaying the unsorted file elements present in array.


	mov ch,04h			;moving size-1 to ch.
outer:
	mov cl,ch
	mov rsi,array
	mov rdi,array+1
inner:
	mov al,[rsi]
	mov bl,[rdi]

	cmp al,bl 			;checcking condition for swap.
	jle skipSwap		;sorting in increasing order so jle used.
	
	mov [rsi],bl
	mov [rdi],al 		;swapping

skipSwap:
	inc rsi
	inc rdi
	dec cl
	jnz inner

	dec ch
	jnz outer
				;elements have been sorted.

	println msg2,len2

	mov cl,05
	mov rsi,array		

dispNext1:	
	mov bl,[rsi]
	push rcx
	push rsi

	call displayNo
	println display,02h
	println space,02h

	pop rsi
	pop rcx

	inc rsi
	dec cl
	jnz dispNext1

				;displaying the sorted array by loop.


	mov rax,01h
	mov rdi,[handle]
	mov rsi,msg2
	mov rdx,len2
	syscall
					;writing the msg2 in the file.
	mov cl,05h
	mov rsi,array
doAgain:
	mov bl,[rsi]

	push rcx
	push rsi

	call displayNo		;calling displayNo to change the current hex value in decimal remember that in displayNo println display,02h line is missing so it is not printing anything on the terminal just converting into decimal.

	mov rax,01h
	mov rdi,[handle]
	mov rsi,display
	mov rdx,02h
	syscall				;writing the decimal numbers in the file.

	mov rax,01h
	mov rdi,[handle]
	mov rsi,space
	mov rdx,01h
	syscall				;writing the space adcajent to numbers in the file.

	pop rsi	
	pop rcx
	
	inc rsi
	dec cl
	jnz doAgain	
					;writing in file done.

	mov rax,03h
	mov rdi,[handle]
	syscall
				;closing the file.

	mov rax,60
	syscall

acceptNo:

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

ret