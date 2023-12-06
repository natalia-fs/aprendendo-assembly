.data
    numero_aleatorio:       .word 0
    limite_min_intervalo:   .word 0
    limite_max_intervalo:   .word 20
    jogador_1_palpite:      .word 0
    jogador_2_palpite:      .word 0
    jogar_novamente:        .word 0

    quantidade_vitorias_jogador_1: .word 0
    quantidade_vitorias_jogador_2: .word 0

    # Strings
    pular_linha:         .asciiz "\n"
    msg_titulo_jogo: .asciiz "--- Advinhe o numero aleatorio entre 0 e 20! ---\n"
    prompt_jogador_1:          .asciiz "Jogador 1, digite um palpite:\n"
    prompt_jogador_2:          .asciiz "Jogador 2, digite um palpite:\n"
    msg_vitoria_jogador_1: .asciiz "Parabéns, Jogador 1! Você venceu!\n"
    msg_vitoria_jogador_2: .asciiz "Parabéns, Jogador 2! Você venceu!\n"
    msg_quantidade_vitorias_jogador_1: .asciiz "Quantidade de vitórias de Jogador 1: "
    msg_quantidade_vitorias_jogador_2: .asciiz "Quantidade de vitórias de Jogador 2: "
    msg_intervalo_invalido: .asciiz "Você só vai acertar se respeitar o intervalo (0 a 20)!\n"
    msg_jogar_novamente: .asciiz "Deseja jogar novamente? (1 para 'SIM', 0 para 'NÃO')\n"
    msg_finalizacao: .asciiz "Obrigada por jogar!\n"

.text
main:
    li $v0, 4                   # Inicialização
    la $a0, msg_titulo_jogo
    syscall

    li $a1, 21                  # intervalo de 0 a 20
    li $v0, 42                  # syscall 42: gera um número aleatório (pseudo-aleatório)
    syscall
    sw $a0, numero_aleatorio    # salva o número aleatório

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

    j loop

receber_palpite_jogador_1:
    li $v0, 4
    la $a0, prompt_jogador_1
    syscall

    li $v0, 5 
    syscall
    sw $v0, jogador_1_palpite       #guarda o palpite do jogador 1 em $v0

    lw $t0, jogador_1_palpite

	lw $t1, limite_max_intervalo
    lw $t3, limite_min_intervalo

    slt $t2, $t1, $t0
    
    slt $t4, $t0, $t3
    or $t5, $t2, $t4
    
    beq $t5, 1, avisar_intervalo

    jr $ra

receber_palpite_jogador_2:
    li $v0, 4                       # syscall para imprimir texto formatado
    la $a0, prompt_jogador_2        # carregar a string prompt_jogador_2 em $a0
    syscall

    li $v0, 5                       # syscall para receber input
    syscall
    sw $v0, jogador_2_palpite       # guarda o palpite do jogador 2 em $v0
	
	lw $t0, jogador_2_palpite
    lw $t1, limite_max_intervalo
    lw $t3, limite_min_intervalo

    slt $t2, $t1, $t0

    slt $t4, $t0, $t3
    or $t5, $t2, $t4

    beq $t5, 1, avisar_intervalo    # Pula pra função de avisar sobre intervalo invalido caso o resultado do OR seja 1

    jr $ra

jogador_1_vitoria:
    li $v0, 4
    la $a0, msg_vitoria_jogador_1
    syscall
    
    lw $t0, quantidade_vitorias_jogador_1
    addi, $t0, $t0, 1
    sw $t0, quantidade_vitorias_jogador_1

    j reiniciar

jogador_2_vitoria:
    li $v0, 4
    la $a0, msg_vitoria_jogador_2
    syscall

    lw $t0, quantidade_vitorias_jogador_2
    addi, $t0, $t0, 1
    sw $t0, quantidade_vitorias_jogador_2

    j reiniciar

avisar_intervalo:
    li $v0, 4
    la $a0, msg_intervalo_invalido
    syscall

    jr $ra

reiniciar:
    jal exibir_quantidade_vitorias_jogador_1
    jal exibir_quantidade_vitorias_jogador_2

    li $v0, 4
    la $a0, msg_jogar_novamente
    syscall

    li $v0, 5
    syscall
    sw $v0, jogar_novamente

    beq $v0, 1, main
    jal finalizar
    
exibir_quantidade_vitorias_jogador_1:
    li $v0, 4
    la $a0, msg_quantidade_vitorias_jogador_1
    syscall

    li $v0, 1
    lw $t0, quantidade_vitorias_jogador_1
    move $a0, $t0
    syscall

    li $v0, 4
    la $a0, pular_linha
    syscall

    jr $ra
    
exibir_quantidade_vitorias_jogador_2:
    li $v0, 4
    la $a0, msg_quantidade_vitorias_jogador_2
    syscall

    li $v0, 1
    lw $t0, quantidade_vitorias_jogador_2
    move $a0, $t0
    syscall

    li $v0, 4
    la $a0, pular_linha
    syscall

    jr $ra

finalizar:
    li $v0, 4
    la $a0, msg_finalizacao
    syscall
    li $v0, 10                # Finalizar o programa
    syscall
