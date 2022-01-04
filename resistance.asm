; System calls
SYS_WRITE		equ		1
; File descriptors
FD_STDOUT		equ		1

; External symbols
extern libPuhfessorP_printSignedInteger64
extern compute_resistance
extern get_resistance
extern show_resistance

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Begin the data section
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section	.data
zero		dq	0.0
; Strings
msg1 		db 	"Found CPU frequency (MHz): "
msg1_len	equ	$-msg1
msg2 		db 	"Unable to find CPU frequency (MHz); Using default value: "
msg2_len	equ	$-msg2
msg3 		db 	13, 10, 13, 10
msg3_len	equ	$-msg3
msg4 		db 	"You have entered nonsense; Returning 0.0 to the driver!", 13, 10, 13, 10
msg4_len	equ	$-msg4
msg5 		db 	"Input successfully received.", 13, 10, 13, 10
msg5_len	equ	$-msg5
msg6 		db 	"Returning the resistance of the system to the driver.", 13, 10, 13, 10
msg6_len	equ	$-msg6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Begin the text section
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section	.text

global resistance

resistance:
	push rbp					; Save rbp
	mov rbp, rsp
	push rbx					; Save rbx
	push r12					; Save r12
		
	mov rbx, 0
	mov ebx, 3400				; The default freqeuncy
	
	mov eax, 0
	push rbx
	cpuid						; Get the max supported function Id	
	pop rbx
	cmp eax, 0x16				; Check if Function ID 0x16 is supported
	jl not_supported			; If its not supported, use the default frequency i.e. 3400MHz 
	
	mov eax, 0x16				; Else Get CPU Frequency
	push rbx
	cpuid
	pop rbx
	mov ebx, eax				; Save frequency in ebx
	mov rsi, msg1				; msg1 address
	mov rdx, msg1_len			; msg1 length
	jmp print

not_supported:	
	
	; Print out the cpu frequency msg
	mov rsi, msg2				; msg2 address
	mov rdx, msg2_len			; msg2 length
print:
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	syscall
	
	; Print out the frequency
	mov rdi, rbx
	call libPuhfessorP_printSignedInteger64
	
	; Print out a new line
	mov rsi, msg3				; msg3 address
	mov rdx, msg3_len			; msg3 length
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	syscall
	
	; Allocate space in stack to store r1, r2, r3, and r4
	sub rsp, 32
	
	; Call C function to get resistances
	mov rdi, rsp
	call get_resistance
	cmp rax, 0					; In case of valid input, compute resistance
	jg compute

	; Print out the 'nonsense' message
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg4				; Provide the memory location to start reading our characters to print
	mov rdx, msg4_len			; Provide the number of characters print
	syscall
	jmp return0
	
compute:	

	; Print out the 'sucess' message
	mov rsi, msg5				; msg3 address
	mov rdx, msg5_len			; msg3 length
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	syscall

	; Get tick count
	mov rax, 0
	mov rdx, 0
	rdtsc
	shl rdx, 32
	or rdx, rax
	mov r12, rdx
	
	; Call C++ function to compute the resistance
	movsd xmm0, [rsp]			; r1
	movsd xmm1, [rsp+8]			; r2
	movsd xmm2, [rsp+16]		; r3
	movsd xmm3, [rsp+24]		; r4
	call compute_resistance			
	
	; Get tick count
	mov rax, 0
	mov rdx, 0
	rdtsc
	shl rdx, 32
	or rdx, rax
	
	; Find tick counts taken
	sub rdx, r12
	mov r12, rdx
	
	; Find CPU Frequency in Hz
	mov rax, rbx
	mov rcx, 1000000
	mul rcx
	
	; Find elapsed time in nano second
	push r12
	fild qword [rsp]			; Push tick counts in FPU stack
	pop r12
	push rax			
	fild qword [rsp]			; Push CPU frequency in FPU stack
	pop rax
	sub rsp, 8
	fstp qword [rsp]			; Store CPU frequency in runtime stack 
	fdiv qword [rsp]	 		; Find tick counts / CPU Frequency
	add rsp, 8
	push 1000000000
	fild qword [rsp]			; Push 1000000000 in FPU stack
	fstp qword [rsp]			; Store CPU frequency in runtime stack
	fmul qword [rsp]			; Convert the result to seconds	
	fstp qword [rsp]			; Store the elapsed time in runtime stack
	
	; Call C++ function to show the resistance
	mov rdi, r12
	movsd xmm1, [rsp]			; Elapsed time
	add rsp, 8
	; Save the resistance as it may get modified
	sub rsp, 16
	movdqu dqword [rsp], xmm0

	call show_resistance
	
	; Restore the resistance
	movdqu xmm0, dqword [rsp]
	add rsp, 16

	jmp return_back
	
return0:	
	movsd xmm0, [zero]

return_back:	

	; Print out the exit message
	mov rax, SYS_WRITE			; System call code goes into rax
	mov rdi, FD_STDOUT			; Tell the system to print to STDOUT
	mov rsi, msg6				; Provide the memory location to start reading our characters to print
	mov rdx, msg6_len			; Provide the number of characters print
	syscall
	
	pop r12
	pop rbx
	mov rsp, rbp
	pop rbp
	ret							; Return
	