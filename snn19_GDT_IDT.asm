%macro println 2
	mov rax,01h
	mov rdi,01h
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .data
	rmsg db 10,'Processor is in Real Mode'
	rlen equ $-rmsg

	pmsg db 10,'Processor is in Protected Mode'
	plen equ $-pmsg

	gdtmsg db 10,'GDT Contents are::'
	gdtlen equ $-gdtmsg

	ldtmsg db 10,'LDT Contents are::'
	ldtlen equ $-ldtmsg

	idtmsg db 10,'IDT Contents are::'
	idtlen equ $-idtmsg

	trmsg db 10,'Task Register Contents are::'
	trlen equ $-trmsg

	mswmsg db 10,'Machine Status Word::'
	mswlen equ $-mswmsg
	
	colon db ':'

section .bss

	gdt resd 1
	    resw 1
	    			;gdt require 6 bytes /1 double = 4 byte/1 word = 2byte

	ldt resw 1		;ldt require 2 bytes 

	idt resd 1
	    resw 1
	    			;idt require 6 bytes 

	tr  resw 1
					;tr require 2 bytes 

	msw resb 4
					;msw require 4 bytes 

	display resb 2



section .text
	global _start

_start:

	smsw eax 	;Reading CR0

	mov [msw],eax	;smsw = store msw  (default)

	shr eax,1
	jc pmode

	println rmsg,rlen

	jmp exit


pmode:	
	println pmsg,plen

	sgdt [gdt]
	sldt [ldt]
	sidt [idt]
	str  [tr]


	println gdtmsg,gdtlen
	
	mov rsi,gdt+5	because of little endian moving rsi to end of gdt.
	;add rsi,05
	mov rcx,06h		;storing the size in rcx.
;	not calling disp because we need to print the colon.


next2:	

	cmp rcx,02h		;comparing rcx value to print colon at appropriate place.
	jne goAhead

	push rsi
	push rcx
	println colon,01h
	pop rcx
	pop rsi

goAhead:


	mov bl,[rsi]

	push rcx
	push rsi
	call displayNo
	pop rsi
	pop rcx
	dec rsi
	dec rcx
	jnz next2		;printing the whole contents of gdtr by loop with colon


	println idtmsg,idtlen
	
	mov rsi,idt+5
	mov rcx,06h
	call disp

	println ldtmsg,ldtlen
	
	mov rsi,ldt+1
	mov rcx,02h
	call disp

	println trmsg,trlen
	
	mov rsi,tr+1
	mov rcx,02h
	call disp

	println mswmsg,mswlen
	
	mov rsi,msw+3
	mov rcx,04h
	call disp
		

exit:
	mov rax,60
	syscall

disp:
next1:
	mov bl,[rsi]
	push rcx
	push rsi
	call displayNo
	pop rsi
	pop rcx

	dec rsi
	dec rcx
	jnz next1
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
