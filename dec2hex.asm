; asmsyntax=nasm

default rel

SYSCALL_CLASS_UNIX 	equ 0x2000000

SYS_EXIT 	equ SYSCALL_CLASS_UNIX + 1
SYS_WRITE	equ SYSCALL_CLASS_UNIX + 4

STDOUT		equ 1

section .data

usage: 	db "Usage: "
.len1:	equ $ - usage
.part2:	db " <number>", 0x0a
.len2:	equ $ - .part2

nl:	db 0x0a

digits: db "0123456789abcdef"

section .bss

argc: 	resd 1
argv:	resq 1

number:	resq 1
buffer:	resb 17

section .text

global _main

_main:	mov [argc], rdi
	mov [argv], rsi
	cmp rdi, 2
	jne print_usage
	
	mov rax, [argv]
	mov rdi, [rax + 8]
	call strlen

	mov rsi, rax
	mov rax, [argv]
	mov rdi, [rax + 8]
	call decton

	mov rsi, rax
	lea rdi, [buffer]
	call ntohex

	mov byte [buffer + 17], 0x0a
	inc rax

	mov rdx, rax
	mov rsi, r8
	mov rdi, STDOUT
	mov rax, SYS_WRITE
	syscall

	xor rdi, rdi
	mov rax, SYS_EXIT
	syscall

; args: buffer to read from, buffer length
; returns the number
decton:	xor rax, rax
	push rbx
	xor rbx, rbx
	mov cl, 4
	mov r8, 10
	xor r9, r9
.loop:	mov bl, [rdi + r9]
	sub bl, '0'
	mul r8
	add rax, rbx
	inc r9
	cmp r9, rsi
	jne .loop
	pop rbx
	ret

; args: buffer to print into (16 bytes long), the number
; returns the length, r8 will contain the actual start of the string
ntohex:	push rbx
	xor rax, rax
	mov rbx, rsi
	mov cl, 4 ; we always shift a single nibble
	xor rdx, rdx
.loop:	mov dl, bl
	and dl, 0xf
	lea r8, [digits]
	add r8, rdx
	mov dl, [r8]
	lea r8, [rdi + 16]
	sub r8, rax
	mov [r8], dl
	inc rax
	shr rbx, cl
	cmp rbx, 0
	jnz .loop
	pop rbx
	ret

; args: none
print_usage:
	mov rdx, usage.len1
	lea rsi, [usage]
	mov rdi, STDOUT
	mov rax, SYS_WRITE
	syscall
	
	mov rbx, [argv]
	mov rdi, [rbx]
	call strlen
	mov rdx, rax
	mov rsi, [rbx]
	mov rdi, STDOUT
	mov rax, SYS_WRITE
	syscall

	mov rdx, usage.len2
	lea rsi, [usage.part2]
	mov rdi, STDOUT
	mov rax, SYS_WRITE
	syscall

	mov rdi, 1
	mov rax, SYS_EXIT
	syscall

strlen:	xor rax, rax
.loop:	cmp byte [rdi + rax], 0
	jz .done
	inc rax
	jmp .loop
.done:	ret
