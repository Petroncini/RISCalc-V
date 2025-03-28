	.data
	.align 0
str0:	.asciz "\nOperação (a, r): "
str1: 	.asciz "\nOperando: "
str2: 	.asciz "\nNo removido: "
str4:	.asciz "Resultado: "
ln:	.asciz "\n"
	.align 2
base:	.word 4
	.text
	.align 2
	.globl main
	
main:
	la t0, base
	sw zero, 0(t0) # zero base->node

main_loop:
	la a0, str0 # printar prompt
	li a7, 4
	ecall
	
	li a7, 12
	ecall
	
	li t0, 'a'
	beq a0, t0, add_node
	
	li t0, 'r'
	beq a0, t0, remove_node
	
add_node:
	la a0, str1
	li a7, 4
	ecall
	
	li a7, 5 # get number from user
	ecall
	
	jal ra, func_add_node
	j main_loop

remove_node:
	jal ra, func_remove_node
	
	la a0, str2 # printa str2
	li a7, 4
	ecall
	
	mv a0, a1 # printa valor do no removido
	li a7, 1
	ecall
	
	j main_loop
	

# funcao adicionar nó
# a0 contém valor a ser adicionado
# retorna nada
func_add_node:
	mv s0, a0 # number to be added
	
	li a7, 9 # alocate node space in heap
	li a0, 8
	ecall
	
	# a0 agora contém endereço de novono
	
	sw s0, 0(a0) # salva valor em novono.num
	
	la t0, base # t0 recebe endereço da base
	lw t1, 0(t0) # t1 receve conteudo da base (endereço do primeiro nó)
	
	sw t1, 4(a0) # salva endereço do primeiro nó em novono.next
	
	sw a0, 0(t0) # salva endereço de novono na base
	
	jr ra
	
# funcao remover nó
# recebe nada
# retorna valor removido em a1
func_remove_node:
	la t0, base # t0 recebe endereço para base
	lw t1, 0(t0) # t1 recebe conteudo da base (endereço do primeiro nó)
	
	beq t1, zero, main_loop # se o conteúdo da base for 0, lista está vazia
	
	
	lw t2, 4(t1) # t2 recebe endereço do segundo nó (base->node->next)
	lw a1, 0(t1) # t1 recebe conteúdo do primeiro no
	
	sw t2, 0(t0) # base recebe endereço do segundo nó (base->node->next)
	
	jr ra
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	







