	.data
	.align 0
str_opr:.asciz	"Operando: "
str_op:	.asciz	"Operacao(+, -, *, /, u, f): "
str_res:.asciz	"Resultado: "
str_und:.asciz 	"Retornou para: "
str_eop:.asciz 	"Operacao invalida, tente novamente"
str_nl:	.asciz	"\n"
	.align 2
base:	.word 0
	.text
	.globl start_up
	
start_up:
	la a0, str_opr # pedir operando 1
	li a7, 4
	ecall
	
	li a7, 5 # ler operando 1
	ecall
	
	mv s0, a0 # s0 recebe operando 1, s0 sempre manterá o total atual

main_loop:
	
	la a0, str_op # pedir operação 
	li a7, 4
	ecall
	
	li a7, 12 # ler operação 
	ecall
	
	mv t1, a0 # t1 recebe operação
	
	jal ra, print_nl # printar nova linha
	
	# switch para não-operações 
	li t0, 'u'
	beq t1, t0, undo
	li t0, 'f'
	beq t1, t0, final
	
	# swtich de operacaoes
	li t0, '+'
	beq t1, t0, add_num
	li t0, '-'
	beq t1, t0, sub_num
	li t0, '*'
	beq t1, t0, mul_num
	li t0, '/'
	beq t1, t0, div_num
	
	# Printando o teste de erro
	li a7, 4
	la a0,str_eop
	ecall
	
	jal ra, print_nl
	
	j main_loop
	
	
add_num:
	jal ra, func_pedir_op2
	mv s1,a0
	add s0, s0, s1 # adiciona operando
	j fim_operacao

sub_num:
	jal ra, func_pedir_op2
	mv s1,a0
	sub s0, s0, s1 # subtrai operando
	j fim_operacao

mul_num:
	jal ra, func_pedir_op2
	mv s1,a0
	mul s0, s0, s1 # multiplica operando
	j fim_operacao

div_num:
	jal ra, func_pedir_op2
	mv s1,a0
	beq s1, zero, func_tratar_zero	# se divide por zero, não realizamos a operação
	div s0, s0, s1 # divide por operando
	j fim_operacao

undo:
	jal ra, func_remove_node # remove no
	
	# se pilha está vazia, volta pra startup
	la t0, base
	lw t0, 0(t0)
	beq t0, zero, start_up
	
	jal ra, func_pegar_topo # pega valor no topo da pilha
	
	bne a1, zero, start_up # se pilha esta vazia, pede nova operaçao
	
	mv s0, a0 # s0 agora eh o topo da pilha
	
	la a0, str_und # printar string de undo
	li a7, 4
	ecall
	
	mv a0, s0 # printar resultado anterior
	li a7, 1
	ecall
	
	jal ra, print_nl # printar nova linha
	
	j main_loop

final:
	li a7, 10 # exit
	ecall
	

fim_operacao:
	mv a0, s0 
	jal ra, func_add_node # salva resultado da operacao na pilha
	
	la a0, str_res # printar string resultado
	li a7, 4
	ecall
	
	mv a0, s0 # printar inteiro resultado
	li a7, 1
	ecall
	
	jal ra, print_nl # printar nova linha
	
	j main_loop
	



# funcao adicionar no
# a0 contem valor a ser adicionado
# retorna nada
func_add_node:
	mv t3, a0 # t3 recebe numero a ser adicionado
	
	li a7, 9 # aloca espaço de um nó na heap 
	li a0, 8
	ecall
	
	# a0 agora contem endereco de novono
	
	sw t3, 0(a0) # salva valor em novono.num
	
	la t0, base # t0 recebe endereco do topo
	lw t1, 0(t0) # t1 recebe conteudo da base (endereco do primeiro no)
	
	sw t1, 4(a0) # salva endereco do primeiro no em novono.next
	
	sw a0, 0(t0) # salva endereco de novono na base
	
	jr ra
	
# funcao para remover no
# recebe nada
# retorna valor removido em a1
func_remove_node:
	la t0, base # t0 recebe endereco para base
	lw t1, 0(t0) # t1 recebe conteudo da base (endereco do primeiro no)
	
	beq t1, zero, start_up # se o conteudo da base for 0, lista esta vazia
	
	
	lw t2, 4(t1) # t2 recebe endereco do segundo no (base->node->next)
	
	sw t2, 0(t0) # base recebe endereco do segundo no (base->node->next)
	
	jr ra
	
# funcao para pegar topo da pilha
# recebe nada
# retorna valor no topo da pilha em a0, status em a1
# a1 0: retornou valor valido
# a1 1: pilha estava vazia

func_pegar_topo:
	la t0, base
	lw t0, 0(t0) # t0 recebe conteudo de base (endereco do topo)
	
	beq t0, zero, pilha_vazia
	
	lw a0, 0(t0) # a0 recebe valor no topo
	li a1, 0 # tudo ok
	
	jr ra
	
	pilha_vazia:
		li a0, 0
		jr ra


# funcao para pedir o operando 2
# recebe nada
# retorna em a0 o valor do operando
func_pedir_op2:
	la a0, str_opr # pedir operando 2
	li a7, 4
	ecall
	
	li a7, 5 # ler operando 2
	ecall
	
	jr ra
	
# funcao printar nova linha
print_nl:
	la a0, str_nl
	li a7, 4
	ecall
	
	jr ra

# função para tratar quando o usuário realiza uma divisão por zero 
# recebe nada 
# retorna nada 
func_tratar_zero:
	# printa uma mensagem de erro 
	la a0, str_eop
	li a7, 4 
	ecall 
	jal print_nl
	# jump para o main_loop
	j main_loop
	
	
