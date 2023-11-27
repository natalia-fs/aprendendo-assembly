.data
    numero_aleatorio:       .word 0
    limite_min_intervalo:   .word 0
    limite_max_intervalo:   .word 20
    jogador_1_palpite:      .word 0
    jogador_2_palpite:      .word 0

    # Strings
    newline:         .asciiz "\n"
    msg_titulo_jogo: .asciiz "Advinhe o numero aleatorio entre 0 e 20!\n"
    prompt_jogador_1:          .asciiz "Jogador 1, digite um palpite:\n"
    prompt_jogador_2:          .asciiz "Jogador 2, digite um palpite:\n"
    msg_vitoria_jogador_1: .asciiz "Parabéns, Jogador 1! Você venceu!"
    msg_vitoria_jogador_2: .asciiz "Parabéns, Jogador 2! Você venceu!"
    msg_intervalo_invalido: .asciiz "Você só vai acertar se respeitar o intervalo (0 a 20)!\n"

.text
main:
    # Inicialização
    li $v0, 4
    la $a0, msg_titulo_jogo
    syscall

    li $a1, 21       # intervalo de 0 a 20
    li $v0, 42       # syscall 42: gera um número aleatório (pseudo-aleatório)
    syscall
    sw $a0, numero_aleatorio  # salva o número aleatório
    # li $v0, 1        # syscall 1: imprime inteiro
    # lw $a0, numero_aleatorio
    # syscall           # imprime o número aleatório

loop:
    # Loop do jogador 1
    jal receber_palpite_jogador_1
    lw $t0, jogador_1_palpite
    lw $t2, numero_aleatorio
    beq $t0, $t2, jogador_1_vitoria

    # Loop do jogador 2
    jal receber_palpite_jogador_2
    lw $t1, jogador_2_palpite
    lw $t3, numero_aleatorio
    beq $t1, $t3, jogador_2_vitoria
		
    # IMPRIME O PALPITE DO PLAYER 2 E O NUMERO ALEATORIO
    # li $v0, 1        # syscall para imprimir inteiro
    # lw $a0, jogador_2_palpite
    # syscall
    # li $v0, 1        # syscall para imprimir inteiro
    # lw $a0, numero_aleatorio
    # syscall

    j loop

receber_palpite_jogador_1:
    li $v0, 4
    la $a0, prompt_jogador_1
    syscall

    li $v0, 5 
    syscall
    sw $v0, jogador_1_palpite  #guarda o palpite do jogador 1 em $v0

    lw $t0, jogador_1_palpite

	lw $t1, limite_max_intervalo
    lw $t3, limite_min_intervalo

    slt $t2, $t1, $t0
    
    slt $t4, $t0, $t3
    or $t5, $t2, $t4
    
    beq $t5, 1, avisar_intervalo

    jr $ra

receber_palpite_jogador_2:
    li $v0, 4                 # syscall para imprimir texto formatado
    la $a0, prompt_jogador_2  # carregar a string prompt_jogador_2 em $a0
    syscall

    li $v0, 5                 # syscall para receber input
    syscall
    sw $v0, jogador_2_palpite   # guarda o palpite do jogador 2 em $v0
	
	lw $t0, jogador_2_palpite
	li $t1, 20

    # slt $t2, $t0, $t1
    slt $t2, $t1, $t0
    
    li $t3, 0

    slt $t4, $t0, $t3
    or $t5, $t2, $t4

    beq $t5, 1, avisar_intervalo

    jr $ra

jogador_1_vitoria:
    li $v0, 4
    la $a0, msg_vitoria_jogador_1
    syscall
    j finalizar

jogador_2_vitoria:
    li $v0, 4
    la $a0, msg_vitoria_jogador_2
    syscall
    j finalizar

avisar_intervalo:
    li $v0, 4
    la $a0, msg_intervalo_invalido
    syscall

    jr $ra

finalizar:
    li $v0, 10                # Finalizar o programa
    syscall
