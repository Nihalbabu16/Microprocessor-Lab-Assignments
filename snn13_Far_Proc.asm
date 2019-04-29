extern acceptstr,occurence,strlen,strlines 
global str1,len1,msg1,lenstr1,msg2,len2
global msg3,len3,msg4,len4,character


%macro println 2
	mov rax,01h
	mov rdi,01h
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .data
menumsg db 10,'Menu'
        db 10,'1.Accept'
	db 10,'2.Length'
	db 10,'3.Occurence'
	db 10,'4.No of Lines, spaces'
	db 10,'5.Exit'
	db 10,10,'Enter Choice  ::'
lenmenu equ $-menumsg	

msg1 db 10,'Enter String ::'
len1 equ $-msg1

msg2 db 10,'Length of String ::'
len2 equ $-msg2


msg3 db 10,'Enter Char for Accur ::'
len3 equ $-msg3

msg4 db 10,'No of Accur are ::'
len4 equ $-msg4





section .bss
choice resb 2
str1 resb 15
lenstr1 resb 1
character resb 2


section .text
	global _start

_start:

menuDisp:
	println menumsg,lenmenu 

	mov rax,00h
	mov rdi,00h
	mov rsi,choice
	mov rdx,02h
	syscall

	cmp byte[choice],31h
	jne next

	call acceptstr
	jmp menuDisp
next:
	cmp byte[choice],32h
	jne next1

	call strlen
	jmp menuDisp
	
next1:
	cmp byte[choice],33h
	jne next2
	call occurence
	jmp menuDisp	

next2:
	cmp byte[choice],34h
	jne next3
	call strlines
	jmp menuDisp

next3:	
	cmp byte[choice],35h
	je exit
	jmp menuDisp

exit:
	mov rax,60
	syscall

