.data
random_number:   .word 0
player1_guess:   .word 0
player2_guess:   .word 0

# Strings
newline:         .asciiz "\n"
msg_titulo_jogo: .asciiz "Advinhe o numero aleatorio entre 0 e 20!\n"
prompt_player_1:          .asciiz "Jogador 1, digite um palpite:\n"
prompt_player_2:          .asciiz "Jogador 2, digite um palpite:\n"
win_msg_player1: .asciiz "Parabéns, Jogador 1! Você venceu!"
win_msg_player2: .asciiz "Parabéns, Jogador 2! Você venceu!"

.text
main:
    # Inicialização
    li $v0, 4
    la $a0, msg_titulo_jogo
    syscall

    li $a1, 21       # intervalo de 0 a 20
    li $v0, 42       # syscall 42: gera um número aleatório (pseudo-aleatório)
    syscall
    sw $a0, random_number  # salva o número aleatório
    # li $v0, 1        # syscall 1: imprime inteiro
    lw $a0, random_number
    syscall           # imprime o número aleatório

loop:
    # Loop do jogador 1
    jal get_guess_player_1
    lw $t0, player1_guess
    lw $t2, random_number
    beq $t0, $t2, player1_win

    # Loop do jogador 2
    jal get_guess_player_2
    lw $t1, player2_guess
    lw $t3, random_number
		
    # IMPRIME O PALPITE DO PLAYER 2 E O NUMERO ALEATORIO
    # li $v0, 1        # syscall 1: imprime inteiro
    # lw $a0, player2_guess
    # syscall
    # li $v0, 1        # syscall 1: imprime inteiro
    # lw $a0, random_number
    # syscall

    beq $t1, $t3, player2_win

    j loop

get_guess_player_1:
    li $v0, 4
    la $a0, prompt_player_1
    syscall

    li $v0, 5
    syscall
    sw $v0, player1_guess  # salva o palpite atual
    jr $ra

get_guess_player_2:
    li $v0, 4
    la $a0, prompt_player_2
    syscall

    li $v0, 5
    syscall
    sw $v0, player2_guess  # salva o palpite atual
    jr $ra

player1_win:
    li $v0, 4
    la $a0, win_msg_player1
    syscall
    j exit

player2_win:
    li $v0, 4
    la $a0, win_msg_player2
    syscall
    j exit

exit:
    li $v0, 10
    syscall
