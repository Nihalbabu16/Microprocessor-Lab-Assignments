.model small

.data
msg db 10,13,'this is sin wave$'

x dd 0.0
xad dd 10.0
one80 dd 180.0
thirty dd 30.0
fifty dd 50.0
ycursor dt 00
count dw 360
x1 dw 0


.code
.386
main:

mov ax,@data
mov ds,ax                                                                                                                                                                                                                                                                                                                                                                       

mov ah,00               ;set video mode
mov al,6
int 10h

up1:

finit
fldpi
fdiv one80
fmul x
fsin
fld thirty
fmul 
fld fifty
fsub st,st(1)  


fbstp ycursor
mov si,offset ycursor

mov ah,0ch              ;write graphics pixel
mov al,01h
mov bh,0h
mov cx,x1
mov dx,[si]
int 10h

inc x1                 
fld x                  
fadd xad               
fst x                  
dec count              
jnz up1                

mov ah,09h                      ; display message
lea dx,msg
int 21h


mov ah,4ch
int 21h
end main

