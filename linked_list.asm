	.data
	.align 0
str3:	.asciz "Operação (a, r): "
str4:	.asciz "Resultado: "
ln:	.asciz "\n"
base:	.space 8
	.text
	.align 2
	.globl main
	
main:
	la t0, base
	sw zero, 0(t0)
	sw zero, 4(t0) # zero base adress

main_loop:
	la a0, str3
	li a7, 4
	ecall
	
	li t0, 'a'
	beq a0, t0, add_node
	
	li t0, 'r'
	beq a0, t0, remove_node
	

add_node:
	li a7, 5 # get number from user
	ecall
	
	mv s0, a0 # number to be added
	
	li a7, 9 # alocate node space in heap
	li a0, 8
	ecall
	
	sw s0, 0(a0) # save value to node.num
	
	la t0, base
	lw t0, 0(t0) # load base address
	
	sw t0, 4(a0) # save base adress to node.next
	
	sw a0, 0(t0) # change base address to point to new node
	
	j main_loop
	
	
	
	
	
	
	

	
	







