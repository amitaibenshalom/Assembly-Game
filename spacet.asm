IDEAL
MODEL small
STACK 100h
DATASEG
xp dw 5
yp dw 100 
colorp dw 99
pass dw 0
pass2 dw 0
xe dw 140
ye dw 0 
colore dw 4
xe2 dw 250
ye2 dw -10
colore2 dw 4
xp1 dw 0
yp1 dw 0 
colorp1 dw 99
pass_exit dw 0
delay1 dw 01H
CODESEG
proc delay
    mov cx, [delay1]
delRep:
	push cx
	mov cx, 0D090H
delDec:
	dec cx
	jnz delDec
	pop cx
	dec cx
	jnz delRep
	ret
endp delay
proc colorsensor
	push bp
	mov bp, sp
	mov bh,0h
	mov cx,[bp + 6]
	mov dx,[bp + 4]
	mov ah,0Dh
	int 10h 
	pop bp
	ret 4
	endp colorsensor
	proc player
	push bp
	mov bp,sp
	mov dx, [bp + 6]
	mov si, 10
col:
	mov di, 10
	mov cx, [bp + 8]
	inc dx
line: 
	mov al, [bp + 4]
	mov ah,0ch
	int 10h
	inc cx
	dec di
	cmp di, 0
	jne line
	dec si
	cmp si, 0
	jne col
	pop bp
	ret 6
endp player
proc enemy
	push bp
	mov bp,sp
	mov dx, [bp + 6]
	mov si, 10
col2:
	mov di, 10
	mov cx, [bp + 8]
	inc dx
line2: 
	mov al, [bp + 4]
	mov ah,0ch
	int 10h
	inc cx
	dec di
	cmp di, 0
	jne line2
	dec si
	cmp si, 0
	jne col2
	pop bp
	ret 6
endp enemy
proc wasd
check:
	mov [pass2], 0
	mov ah, 1h
	int 16h
	jnz jumptowhich
	push [xe2]
	push [ye2]
	push [colore2]
	call enemy
	push [xe]
	push [ye]
	push [colore]
	call enemy
	push [xp]
	push [yp]
	call colorsensor
	cmp al, 4
	je jstart
	add [xp], 9
	add [yp], 9
	push [xp]
	push [yp]
	call colorsensor
	sub [xp], 9
	sub [yp], 9
	cmp al, 4
	je jstart
	call delay
	mov [colore], 0
	push [xe]
	push [ye]
	mov [pass2], 1
jumptocheck:
	cmp [pass2], 0
	je check
jumptowhich:
	cmp [pass2], 0
	je which
jstart:
	cmp [pass2], 0
	je myend
	push [colore]
	call enemy
	mov [colore2], 0
	push [xe2]
	push [ye2]
	push [colore2]
	call enemy
	cmp [ye], 190
	jne continue
	mov [ye], 0
continue:
	add [ye], 5
	mov [colore], 4
	cmp [ye2], 190
	jne continue2
	mov [ye2], -10
continue2:
	add [ye2], 10
	mov [colore2], 4
	mov [pass2], 0
	jmp jumptocheck 
which:
	mov ah,0
	int 16h
myend:
	ret 
	endp wasd
win:
	mov [colorp], 48
	push [xp]
	push [yp]
	push [colorp]
	call player
	mov [delay1], 10h
	call delay
	mov [pass_exit], 1
	jmp jumptoexit
start:
	mov ax, @data
	mov ds, ax
	mov ax, 13h
	int 10h
	mov bh,0h
	mov [delay1], 01H
	mov [pass_exit], 0
	mov [xp], 5
	mov [yp], 100
	push [xp]
	push [yp]
	push [colorp]
	call player
move:
	mov [pass], 0
	call wasd
	cmp al, 4
	je start
d: 
	cmp al, 100
	jne w
	cmp [xp], 310
	je win
	mov [colorp], 0
	push [xp]
	push [yp]
	push [colorp]
	call player
	mov [colorp], 99
	add [xp], 5
	push [xp]
	push [yp]
	push [colorp]
	call player
	jmp move
	jumptoexit:
	cmp [pass_exit], 1
	je jumptoexit2
w:
	cmp al, 119
	jne a
	cmp [yp], 0
	je move
	mov [colorp], 0
	push [xp]
	push [yp]
	push [colorp]
	call player
move2:
	cmp [pass], 1
	je move
	mov [colorp], 99
	sub [yp], 5
	push [xp]
	push [yp]
	push [colorp]
	call player
	jmp move
a: 
	cmp al, 97
	jne s
	inc [pass]
	cmp [xp], 0
	je move2
	mov [colorp], 0
	push [xp]
	push [yp]
jumptoexit2:
	cmp [pass_exit], 1
	je exit
	push [colorp]
	call player
	mov [colorp], 99
	sub [xp], 5
	push [xp]
	push [yp]
	push [colorp]
	call player
	jmp move2
move3:
	cmp [pass], 1
	je move2
s: 
	cmp al, 115
	jne spacebar
	inc [pass]
	cmp [yp], 190
	je move3
	mov [colorp], 0
	push [xp]
	push [yp]
	push [colorp]
	call player
	mov [colorp], 99
	add [yp], 5
	push [xp]
	push [yp]
	push [colorp]
	call player
	jmp move3
spacebar:
	inc [pass]
	cmp al, 32
	jne move3
exit:
mov ax, 4c00h
int 21h
END start
