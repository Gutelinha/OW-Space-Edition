call menu
jmp main

; Variáveis

score: var #1 			; Pontos
vidas: var #1 			; Vidas

posZen1: var #1		; Coordenada 1
posZen2: var #1 		; Coordenada 2
flagTiroZen: var #1    ; Flag se Zen atirou
posTiroZen: var #1     ; Posição tiro Zen (armazena a coordenada da esqueda, na hora de imprimir é somado 1 para imprimir o da direita)

posEnemy1: var #1 		; Coordenada e1
posEnemy2: var #1 		; Coordenada e2
flagTiroEnemy: var #1   ; Flag se Enemy atirou
posTiroEnemy: var #1 	; Posição tiro Zen (armazena a coordenada da esqueda, na hora de imprimir é somado 1 para imprimir o da direita)

IncRand: var #1			; Incremento para circular na Tabela de nr. Randomicos
Rand : var #50			; Tabela de nr. Randomicos entre 0 - 1. Para movimentação do Enemy (0 == esq && 1 == dir).
	static Rand + #0, #1
	static Rand + #1, #1
	static Rand + #2, #0
	static Rand + #3, #1
	static Rand + #4, #1
	static Rand + #5, #1
	static Rand + #6, #0
	static Rand + #7, #1
	static Rand + #8, #0
	static Rand + #9, #0
	static Rand + #10, #1
	static Rand + #11, #0
	static Rand + #12, #0
	static Rand + #13, #1
	static Rand + #14, #0
	static Rand + #15, #0
	static Rand + #16, #1
	static Rand + #17, #0
	static Rand + #18, #0
	static Rand + #19, #1
	static Rand + #20, #1
	static Rand + #20, #1
	static Rand + #21, #0
	static Rand + #22, #1
	static Rand + #23, #1
	static Rand + #24, #0
	static Rand + #25, #0
	static Rand + #26, #1
	static Rand + #27, #0
	static Rand + #28, #0
	static Rand + #29, #1
	static Rand + #30, #0
	static Rand + #31, #0
	static Rand + #32, #0
	static Rand + #33, #1
	static Rand + #34, #0
	static Rand + #35, #1
	static Rand + #36, #1
	static Rand + #37, #1
	static Rand + #38, #0
	static Rand + #39, #0
	static Rand + #40, #1
	static Rand + #41, #0
	static Rand + #42, #0
	static Rand + #43, #0
	static Rand + #44, #1
	static Rand + #45, #1
	static Rand + #46, #0
	static Rand + #47, #1
	static Rand + #48, #1
	static Rand + #49, #0

endscreen:
	loadn r0, #0 					; Posição do começo da tela
	loadn r1, #endscreenLinha0 		; Endereço da tela na memória
	call printTela 				    ; print tela

	
	loadn r1, #582  		; Posição para imprimir os pontos
	load r0, score 			; r0 = score
	loadn r2, #100 			; r2 = 100
	div r3, r0, r2 			; r3 = r0 / r2    ->   pega o dígito da centena
	loadn r4, #48 			; r4 = 48
	add r3, r3, r4 			; r3 += r4  ->  converte o dígito para o seu valor na tabela ASCII, por exemplo o dígito 5 é representado pelo número 53 na tabela
	outchar r3, r1 			; print a centena
	sub r3, r3, r4 			; r3 -= r2  ->  volta do valor da tabela ASCII para o dígito
	mul r3, r3, r2 			; r3 *= r2  ->  multiplica o dígita da centena por 100
	sub r0, r0, r3 			; r0 -= r3  ->  remove as centenas

							; EXEMPLO:
							; 365 -> 365 / 100 = 3 -> dígito da centena = 3 -> print o 3 -> subtrai 3 * 100 do total de pontos ->
							; -> 523 - 3 * 100 = 65 -> segue processo análogo para dezena e unidade

	; DEZENA NO SCORE
	inc r1
	loadn r2, #10 
	div r3, r0, r2 
	loadn r4, #48
	add r3, r3, r4
	outchar r3, r1
	sub r3, r3, r4
	mul r3, r3, r2
	sub r0, r0, r3

	; UNIDADE DO SCORE
	inc r1
	add r0, r0, r4
	outchar r0, r1

	endscreenLerCaractere:
	inchar r0 			; le tecla

	loadn r1, #13 		; r1 = 13 = ENTER
	cmp r0,r1
	jeq main 			; se ENTER foi pressionado, quer jogar denovo, então pula pra main
	
	loadn r1, #' ' 		; r1 = SPACE
	cmp r0, r1
	jeq fim  			; se SPACE foi pressionado, quer sair, então pula pro fim

	jmp endscreenLerCaractere  ; se nenhuma das teclas de interesse foi pressionada, volta pro endscreenLerCaractere

menu:
	push r1
	push r2

	loadn r1, #tela0Linha0 ; Endereco onde comeca a primeira linha da tela
	loadn r2, #0  		   ; Cor branca
	call printTela
	
	loadn r2, #13  		   ; r2 = 13 = ENTER
	; Enquanto enter não for pressionado le a tecla
	lerTecla:
	inchar r1
	cmp r1, r2
	jne lerTecla 			; if (r1 != ENTER) lerTecla

	call clearTela  		; clear a tela e volta pra main

	pop r2
	pop r1

	rts

main:
 	call clearTela   		; Limpa a tela

	loadn r0, #3 			
	store vidas, r0 		; Quantidade de vidas

	loadn r0, #0
	store score, r0 		; Zera os pontos 

	loadn r0, #1059			; Posição Zen1
	store posZen1, r0
	loadn r0, #1099			; Posição Zen2
	store posZen2, r0
	loadn r0, #0
	store flagTiroZen, r0 	; Zera flag de tiro da Zen

	loadn r0, #19 			; Posição Enemy1
	store posEnemy1, r0
	loadn r0, #59
	store posEnemy2, r0 	; Posição Enemy2
	loadn r0, #0
	store flagTiroEnemy, r0 ; Zera flag de tiro do Enemy
	
	loadn r0, #0 			; Contador para os mods = 0
	loadn r2, #0 			; Para verificar se r0 % x == 0

	call printHud 		; print as palavras SCORE: e VIDAS: 

	jmp loop 				; pula pro loop



loop:
	; Os mods servem para executar as ações somente nos ciclos em que o contador é múltiplo de algum número.
	; Se r0 % 7 == 0
	; movimentação da Zen
	loadn r1, #7
	mod r1, r0, r1
	cmp r1, r2
	ceq Zen
	
	; Se r0 % 2 == 0
	; tiro da Zen
	loadn r1, #2
	mod r1, r0, r1
	cmp r1, r2
	ceq tiroZen

	; Se r0 % 25 == 0
	; movimentação do Enemy
	loadn r1, #25
	mod r1, r0, r1
	cmp r1, r2
	ceq Enemy

	; Se r0 % 250 == 0
	; frequência de tiro do Enemy 
	loadn r1, #250
	mod r1, r0, r1
	cmp r1, r2
	ceq EnemyAtirou

	; Se r0 % 3 == 0
	; tiro do Enemy
	loadn r1, #3
	mod r1, r0, r1
	cmp r1, r2
	ceq tiroEnemy

	call comparaPosicaoTiroZen		; compara a posição do tiro da Zen com o Enemy

	call printValoresHud 			; print os valores dos pontos e das vidas

	push r0 			; protege r0
	push r1 			; protege r1
	loadn r0, #0
	load r1, vidas
	cmp r0, r1
	jeq endscreen 		; if (vidas == 0) chama a funcao de imprimir o fim de jogo
	pop r1 				; protege r1
	pop r0 				; protege r0
	
	call Delay 				; Delay
	inc r0					; Incrementa contador dos mods - r0++
	jmp loop


; IMPRIMIR O HUD DO JOGO (SCORE E VIDA)
printHud:
	push r0
	push r1

	loadn r0, #1160  	 	; posição para começar imprimir
	loadn r1, #stringHud 	; endereço da string
	call printStr 		; print

	pop r1
	pop r0

	rts

; print OS VALORES DE SCORE E VIDA
printValoresHud:
	push r0
	push r1
	push r2
	push r3
	push r4

	; print as vidas, valores somente de 0 a 9
	load r0, vidas 	 	; r0 = vidas
	loadn r1, #48 		
	add r0, r0, r1 		; converte pra valor do dígito na tabela ASCII
	loadn r1, #1198  	; lugar da tela para imprimir
	outchar r0, r1 		; print

	; print os pontos
	loadn r1, #1168
	load r0, score
	loadn r2, #100
	div r3, r0, r2
	loadn r4, #48
	add r3, r3, r4
	outchar r3, r1
	sub r3, r3, r4
	mul r3, r3, r2
	sub r0, r0, r3

	inc r1
	loadn r2, #10
	div r3, r0, r2
	loadn r4, #48
	add r3, r3, r4
	outchar r3, r1
	sub r3, r3, r4
	mul r3, r3, r2
	sub r0, r0, r3

	inc r1
	add r0, r0, r4
	outchar r0, r1

	pop r4
	pop r3
	pop r2
	pop r1
	pop r0

	rts

; COLISAO TIRO/Enemy
comparaPosicaoTiroZen:
	push r0 
	push r1 
	
	load r0, posTiroZen	; pos tiro 1 (esquerda)
	load r1, posEnemy1		; pos Enemy 1 (esquerda)
	cmp r0, r1 				; compara tiro 1 com Enemy 1
	ceq somaPonto
	
	inc r1 					; pos Enemy 2 (direita)
	
	cmp r0, r1 				; compara tiro 1 com Enemy 2
	ceq somaPonto
	
	inc r0					; pos tiro 2 (direita)
	
	cmp r0, r1 				; compara tiro2 com Enemy 2
	ceq somaPonto
	
	dec r1					; pos Enemy 1 (esquerda)
	
	cmp r0, r1 				; compara tiro2 com Enemy 1
	ceq somaPonto
	
	pop r1 
	pop r0
	
	rts
	
somaPonto:
	push r0 
	push r1 
	
	load r0, score			; pega o valor da score na memória
	
	inc r0 					; incrementa 1
	store score, r0 		; armazena de volta na memória
	
	loadn r0, #0			; reseta a posição do tiro da Zen
	store posTiroZen, r0 	; evita que fique somando infinitamente
	
	pop r1 
	pop r0 
	
	rts

; DECREMENTA VIDA
decVidas:
	push r0

	load r0, vidas 		; seta r0 como vidas
	dec r0 				; decrementa o valor da vida caso a Zen receba "dano"
	store vidas, r0 	; armazena vidas

	pop r0

	rts

; FUNCAO Zen (desenha, clear, compara, etc)
Zen:
	call ZenDesenhar
	call ZenMover
	
	rts

ZenDesenhar:
	; Zen #$
	;     %&

	push r0
	push r1

	loadn r0, #'#'  	; r0 = caractere Zen superior esquerda (#)
	load r1, posZen1	; r1 = posição Zen superior esquerda
	outchar r0, r1		; desenha parte superior esquerda da Zen

	inc r0              ; incrementa o char do r0 ($)
	inc r1				; incrementa r1 para ir para a segunda parte de cima da Zen e desenha-la
	outchar r0, r1		; desenha parte superior direita da Zen

	inc r0   	        ; incrementa o char do r0 (%)
	load r1, posZen2	; incrementa r1 e vai para a parte de baixo da Zen
	outchar r0, r1		; desenha parte inferior esquerda da Zen

	inc r0              ; incrementa o char do r0 (&)
	inc r1				; incrementa r1
	outchar r0, r1		; desenha parte inferior direita da Zen

	pop r1
	pop r0

	rts

Zenclearr:
	push r0
	push r1
	push r2
	
	loadn r0, #' '			; r0 = ' '
	load r1, posZen1		; r1 = posição Zen1
	load r2, posZen2		; r2 = posição Zen2

	outchar r0, r1			; print ' ' na primeira parte do zen
	outchar r0, r2			; print ' ' na segunda parte do zen

	inc r1					; r1++ (posição Zen3)
	inc r2					; r2++ (posição Zen4)

	outchar r0, r1			; print ' ' na terceira parte do zen
	outchar r0, r2			; print ' ' na quarta parte do zen

	pop r2
	pop r1
	pop r0

	rts

ZenMover:
	push r0
	push r1
	push r2
	push r3

	inchar r0			; Le a tecla digitada
	
	loadn r1, #'a'		; Se a tecla digitada for a, move pra esquerda (NAO PODE SER EM CAPS!!!!)
	cmp r0, r1
	ceq	ZenMoveEsq

	loadn r1, #'d' 		; Se a tecla digitada for d, move pra direita (NAO PODE SER EM CAPS!!!!)
	cmp r0, r1
	ceq ZenMoveDir

	loadn r1, #' '
	load r2, flagTiroZen
	loadn r3, #1
	cmp r2, r3
	jeq ZenAtirou_Skip 	; Se a flag de tiro já está em 1 pula
	cmp r0, r1 				; Se SPACE foi pressionado e a flag de tiro está em 0, chama ZenAtirou
	ceq ZenAtirou
	ZenAtirou_Skip:

	pop r3
	pop r2
	pop r1
	pop r0

	rts

ZenMoveEsq:
	push r0
	push r1

	; Caso em que a Zen está na borda
	load r0, posZen1
	loadn r1, #1041
	cmp r0, r1
	jle ZenMoveEsq_skip	; if (posZen1 < 1041) não move

	call Zenclearr			; clear a Zen

	; Decrementa a posição da Zen
	load r0, posZen1
	load r1, posZen2
	dec r0
	dec r1
	store posZen1, r0
	store posZen2, r1

	call ZenDesenhar		; Desenha a Zen na nova coordenada

	ZenMoveEsq_skip:		; Label para não mover a Zen

	pop r1
	pop r0

	rts

ZenMoveDir:
	push r0
	push r1

	; Caso em que a Zen está na borda
	load r0, posZen1
	loadn r1, #1077
	cmp r0, r1
	jgr ZenMoveDir_skip 	; if (posZen1 > 1077) não move

	call Zenclearr			; clear a Zen

	; Incrementa a posição da Zen
	load r0, posZen1
	load r1, posZen2
	inc r0
	inc r1
	store posZen1, r0
	store posZen2, r1

	call ZenDesenhar		; Desenha a Zen na nova coordenada

	ZenMoveDir_skip:		; Label para não mover a Zen

	pop r1
	pop r0

	rts

; FUNCAO DE TIRO PARA o Zen
ZenAtirou:
	push r0

	loadn r0, #1
	store flagTiroZen, r0		; flagTiroZen = 1
	load r0, posZen1
	store posTiroZen, r0       ; posTiroZen = posZen1

	pop r0
	
	rts
	
tiroZen:
	push r0
	push r1

	loadn r0, #1
	load r1, flagTiroZen
	cmp r0, r1
	ceq tiroZenMover 			; Se flagTiroZen == 1 chama tiroZenMover

	pop r1
	pop r0

	rts

tiroZenMover:
	push r0
	push r1
	push r2

	load r0, posTiroZen		; r0 = posTiroZen
	call tiroZenclearr 		; clear tiro
	loadn r2, #40 				; move a posição do tiro uma linha pra cima
	sub r0, r0, r2

	loadn r1, #40
	cmp r0, r1
	cle tiroZenPassouPrimeiraLinha ; if (posTiro < 40) passouPrimeiraLinha


	store posTiroZen, r0  			; armazena nova posição na variavel
	call tiroZenDesenhar 			; desenha o tiro

	pop r2
	pop r1
	pop r0

	rts

tiroZenPassouPrimeiraLinha:
	push r0

	; flagTiroZen = 0
	loadn r0, #0
	store flagTiroZen, r0

	pop r0

	rts

tiroZenDesenhar:
	push r1 
	push r2 
	
	load r1, flagTiroZen
	loadn r2, #0
	cmp r1, r2
	jeq tiroZenDesenhar_Skip 	; se (flagTiro == 0) ele skipa

	load r1, posTiroZen
	loadn r2, #'('
	outchar r2, r1 				; Desenha '(' na posicao do tiro da Zen (esquerda)
	
	inc r1
	loadn r2, #')'					
	outchar r2, r1 				; Desenha ')' na posicao mais 1 no caso direita
	
	tiroZenDesenhar_Skip:
	pop r2
	pop r1 
	
	rts

tiroZenclearr:
	push r0
	push r1
	push r2

	loadn r0, #' '
	load r1, posTiroZen

	; if (posTiro == posZen) skip  
	load r2, posZen1
	cmp r1, r2
	jeq tiroZenclearr_Skip

	outchar r0, r1  		; Desenha ' ' na posTiroZen
	inc r1
	outchar r0, r1 			; Desenha ' ' na posTiroZen + 1

	tiroZenclearr_Skip:

	pop r2
	pop r1
	pop r0

	rts

; ENEMY
Enemy:
	call EnemyDesenhar
	call EnemyMover

	rts

EnemyDesenhar:

	push r0
	push r1

	loadn r0, #0
	load r1, posEnemy1
	outchar	r0, r1

	inc r0
	inc r1
	outchar r0, r1

	inc r0
	load r1, posEnemy2
	outchar r0, r1

	inc r0
	inc r1
	outchar r0, r1

	pop r1
	pop r0

	rts

Enemyclearr:
	push r0
	push r1

	loadn r0, #' '
	load r1, posEnemy1
	outchar r0, r1

	inc r1
	outchar r0, r1

	load r1, posEnemy2
	outchar r0, r1

	inc r1
	outchar r0, r1

	pop r1
	pop r0

	rts

EnemyMover:
	push r0
	push r1
	push r2

	loadn r0, #Rand 		; ponteiro para a tabela Rand (movimento do enemy!)
	load r1, IncRand 		; incremento da tabela Rand
	add r0, r0, r1 			; soma incremento no ponteiro

	loadi r2, r0 			; r2 = rand[r0]

	inc r1 					

	loadn r0, #50
	cmp r1, r0
	jne EnemyMover_skipResetTabela ; if (r1 != 50) não reseta a tabela
	loadn r1, #0 				   ; else reseta -> r1 = 0
	EnemyMover_skipResetTabela:
	store IncRand, r1 			   ; armazena novo IncRand

	loadn r0, #0 				   ; if (r2 == 0) --> enemy go to esquerda	
	cmp r0, r2
	ceq EnemyMoverEsq

	loadn r0, #1 				   ; if (r2 == 1) --> enemy go to direita
	cmp r0, r2
	ceq EnemyMoverDir

	pop r2
	pop r1
	pop r0

	rts

EnemyMoverEsq:
	push r0
	push r1

	load r0, posEnemy1
	loadn r1, #1
	cmp r0, r1
	jle EnemyMoverEsq_Skip  ; impede de mover caso esteja no limite esquerdo

	call Enemyclearr 		; clear o Enemy

	; Decrementa pos
	load r0, posEnemy1
	load r1, posEnemy2
	dec r0
	dec r1
	store posEnemy1, r0
	store posEnemy2, r1

	call EnemyDesenhar

	EnemyMoverEsq_Skip:

	pop r1
	pop r0

	rts

EnemyMoverDir:
	push r0
	push r1

	load r0, posEnemy1 		; impede de mover alem da borda
	loadn r1, #37
	cmp r0, r1
	jgr EnemyMoverDir_Skip

	call Enemyclearr 		; clear o Enemy

	; Incrementa pos
	load r0, posEnemy1
	load r1, posEnemy2
	inc r0
	inc r1
	store posEnemy1, r0
	store posEnemy2, r1

	call EnemyDesenhar

	EnemyMoverDir_Skip:

	pop r1
	pop r0

	rts

;Tiro Enemy
EnemyAtirou:
	push r0
	push r1

	loadn r0, #1
	load r1, flagTiroEnemy
	cmp r0, r1
	jeq EnemyAtirou_Skip  		; se flagTiroEnemy já está em 1, pula, para não resetar indevidamente posTiroEnemy

	loadn r0, #1
	store flagTiroEnemy, r0		; flagTiroEnemy = 1
	load r0, posEnemy2
	store posTiroEnemy, r0       ; posTiroEnemy = posEnemy2

	EnemyAtirou_Skip:

	pop r1
	pop r0
	
	rts
	
tiroEnemy:
	push r0
	push r1

	loadn r0, #1
	load r1, flagTiroEnemy
	cmp r0, r1
	ceq tiroEnemyMover 			; Se flagTiroEnemy == 1 chama tiroEnemyMover

	pop r1
	pop r0

	rts

tiroEnemyMover:
	push r0
	push r1
	push r2

	load r0, posTiroEnemy		; r0 = posTiroEnemy
	call tiroEnemyclearr 		; clear tiro
	loadn r2, #40 				; move a posição do tiro uma linha pra baixo
	add r0, r0, r2

	loadn r1, #1080
	cmp r0, r1
	cgr tiroEnemyPassouUltimaLinha ; if (posTiro > 1080) passouUltimaLinha

	load r1, posZen1
	cmp r0, r1
	ceq decVidas
	inc r1
	cmp r0, r1
	ceq decVidas
	dec r1
	dec r1
	cmp r0, r1
	ceq decVidas

	store posTiroEnemy, r0  			; armazena nova posição na variavel
	call tiroEnemyDesenhar 			 	; desenha o tiro

	pop r2
	pop r1
	pop r0

	rts

tiroEnemyPassouUltimaLinha:
	push r0

	; flagTiroEnemy = 0
	loadn r0, #0
	store flagTiroEnemy, r0

	pop r0

	rts

tiroEnemyDesenhar:
	push r1 
	push r2 
	
	load r1, flagTiroEnemy
	loadn r2, #0
	cmp r1, r2
	jeq tiroEnemyDesenhar_Skip 	; if (flagTiroEnemy == 0) skip

	load r1, posTiroEnemy
	loadn r2, #4
	outchar r2, r1 				; Desenha ' |' na posTiroEnemy
	
	inc r2
	inc r1 						
	outchar r2, r1 				; Desenha '| ' na posTiroEnemy + 1
	
	tiroEnemyDesenhar_Skip:
	pop r2
	pop r1 
	
	rts

tiroEnemyclearr:
	push r0
	push r1
	push r2

	loadn r0, #' '
	load r1, posTiroEnemy

	; if (posTiroAlein == posEnemy2) skip  
	load r2, posEnemy2
	cmp r1, r2
	jeq tiroEnemyclearr_Skip

	outchar r0, r1  		; Desenha ' ' na posTiroEnemy
	inc r1
	outchar r0, r1 			; Desenha ' ' na posTiroEnemy + 1

	tiroEnemyclearr_Skip:

	pop r2
	pop r1
	pop r0

	rts

;print TELA

printTela: 	
	;  Rotina de Impresao de Cenario na Tela Inteira
	;  r1 = endereco da primeira linha
	;  r2 = cor do Cenario
	;protecao de registradores na stack
	push r0	
	push r1	
	push r2	
	push r3
	push r4	
	push r5	
	
	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	
   printTela_Loop:
		call printStr
		add r0, r0, r3  	; incrementa posicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!)
		cmp r0, r5			; Compara r0 com 1200
		jne printTela_Loop	; Enquanto r0 < 1200

	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5	
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts			

;Impressao de strings

printStr:	
	;r0 = Posicao da tela que o primeiro caractere da mensagem sera impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.
	;protecao de registradores no stack
	push r0	
	push r1	
	push r2	
	push r3	
	push r4	
	
	loadn r3, #'\0'	; condicao de saida

   printStr_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq printStr_Sai
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; print o caractere na tela
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		jmp printStr_Loop
	
   printStr_Sai:	
	pop r4	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;Screen clear

clearTela:
	push r0
	push r1
	
	loadn r0, #1200		; clear as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	   clearTela_Loop:	;;label for(r0=1200;r3>0;r3--)
		dec r0
		outchar r1, r0
		jnz clearTela_Loop
 
	pop r1
	pop r0
	rts	

;DELAY		

Delay:
						;protecao dos registradores da main
	Push R0
	Push R1
	
	Loadn R1, #50  ; a
   Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	Loadn R0, #3000	; b
   Delay_volta: 
	Dec R0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	JNZ Delay_volta	
	Dec R1
	JNZ Delay_volta2
	
	Pop R1
	Pop R0
	
	RTS							;return


; SCREENS
;	Menu
tela0Linha0  : string "                                        "
tela0Linha1  : string "                                        "
tela0Linha2  : string "                                        "
tela0Linha3  : string "          _____    _             _      "
tela0Linha4  : string "         / ___ {  | |           | |     "
tela0Linha5  : string "        / /   { {  | |   ___   | |      "
tela0Linha6  : string "       | |     | | | |  / _ {  | |      "
tela0Linha7  : string "       | |     | |  | || | | || |       "
tela0Linha8  : string "       | |     | |  | || | | || |       "
tela0Linha9  : string "        { {___/ /   | || | | || |       "
tela0Linha10 : string "         {_____/     |__|   |__|        "
tela0Linha11 : string "                                        "
tela0Linha12 : string "         OverWatch Space Edition        "
tela0Linha13 : string "                                        "
tela0Linha14 : string "                                        "
tela0Linha15 : string "                                        "
tela0Linha16 : string "                                        "
tela0Linha17 : string "         By: Guto, Tanus e Pablo        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "                 BSI 022                "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "   Aperte (ENTER) para comecar o jogo   "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "

; FIM DE JOGO
endscreenLinha0  : string "                                        "
endscreenLinha1  : string "                                        "
endscreenLinha2  : string "                                        "
endscreenLinha3  : string "                                        "
endscreenLinha4  : string "                                        "
endscreenLinha5  : string "                                        "
endscreenLinha6  : string "                                        "
endscreenLinha7  : string "                                        "
endscreenLinha8  : string "          F I M  D E  J O G O           "
endscreenLinha9  : string "                                        "
endscreenLinha10 : string "   O Bastion infelizmente ganhou ;-;    "
endscreenLinha11 : string "                                        "
endscreenLinha12 : string "                                        "
endscreenLinha13 : string "                                        "
endscreenLinha14 : string "           SEU SCORE:                   "
endscreenLinha15 : string "                                        "
endscreenLinha16 : string "                                        "
endscreenLinha17 : string "                                        "
endscreenLinha18 : string "                                        "
endscreenLinha19 : string "     Deseja jogar novamente? (ENTER)    "
endscreenLinha20 : string "                                        "
endscreenLinha21 : string "        Tecle (SPACE) para sair         "
endscreenLinha22 : string "                                        "
endscreenLinha23 : string "                                        "
endscreenLinha24 : string "                                        "
endscreenLinha25 : string "                                        "
endscreenLinha26 : string "                                        "
endscreenLinha27 : string "                                        "
endscreenLinha28 : string "                                        "
endscreenLinha29 : string "                                        "

; HUD
stringHud : string " SCORE:                         VIDAS:   "

fim: