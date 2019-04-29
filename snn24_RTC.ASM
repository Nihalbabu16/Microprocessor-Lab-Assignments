.model tiny

.code
org 100h
start:
      jmp trans

intvect8 dd ?
hr db ?
min db ?
sec db ?
cnt db 00h

resi:
        push ax
        push bx
        push cx
        push dx

        push si
        push di
        push sp
        push bp

        push ss
        push es
        push ds

        


        mov ah,02h
        int 1ah

        mov cs:hr,ch
        mov cs:min,cl
        mov cs:sec,dh

        mov ax,0b800h
        mov es,ax
        mov di,140

        mov al,cs:sec
        and al,0f0h
        mov cl,04h
        shr al,cl
        add al,30h
        mov es:[di],al

        inc di
        inc di

        mov al,cs:sec
        and al,0fh
        add al,30h
        mov es:[di],al

        inc cs:cnt
        cmp cs:cnt,91

        jne next        
        mov cs:cnt,00h

        call beep
next:
        pop ds
        pop es
        pop ss

        pop bp
        pop sp
        pop di
        pop si

        pop dx
        pop cx
        pop bx
        pop ax
        jmp dword ptr cs:intvect8

beep proc near
        mov al,182
        out 43h,al

        mov ax,4560
        out 42h,al
        mov al,ah
        out 42h,al

        in al,61h
        or al,00000011b
        out 61h,al

        mov bx,00ffh
outer:        
        mov cx,0ffffh
again:
        dec cx
        jnz again

        dec bx
        jnz outer
                
        in al,61h
        and al,11111100b
        out 61h,al
ret
beep endp

trans:
        cli

        mov ah,35h
        mov al,08h
        int 21h

        mov word ptr intvect8,bx
        mov word ptr intvect8+2,es

        mov ah,25h
        mov al,08h
        mov dx,offset resi
        int 21h

        sti

        mov ah,31h
        mov dx,offset trans
        int 21h
end start
