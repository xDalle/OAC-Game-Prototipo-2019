.eqv left 97
.eqv right 100
.eqv shoot 119
.eqv esc 27
.eqv space 32
.eqv bitmap_largura 320
.eqv bitmap_altura 240
.data

####################################################################################################
#												   #
#                       		    .data					           #
#                                      	     	                                                   #
####################################################################################################

L: .string "L"
R: .string "R"
S: .string "S"
E: .string "E"

cor_parede: .word 0x63636363
cor_background: .word 0x89898989

background_position_0: .word 0xFF000000
background_position_1: .word 0xFF100000

nave_position_0: .word 0xff00e198
nave_position_1: .word  0xff10e198
nave_position_frame_anterior_0: .word 0xff00e198
nave_position_frame_anterior_1: .word   0xff10e198
nave_speed: .word 8

bullet_position_0: .word 0xff00e198
bullet_position_1: .word   0xff10e198
bullet_position_frame_anterior_0: .word 0xff00e198
bullet_position_frame_anterior_1: .word 0xff10e198
bullet_alive: .word 0

navio_position_0: .word 0xff00e198
navio_position_1: .word 0xff10e198
navio_position_frame_anterior_0: .word 0xff00e198
navio_position_frame_anterior_1: .word 0xff10e198
navio_speed: .word 4
navio_alive: .word 0

vida1_position_0: .word 0xff111308
vida1_position_1: .word 0xff011308
vida1_position_frame_anterior_0: .word 0xff011308
vida1_position_frame_anterior_1: .word 0xff111308

vida2_position_0: .word 0xff01131c
vida2_position_1: .word 0xff11131c
vida2_position_frame_anterior_0: .word 0xff01131c
vida2_position_frame_anterior_1: .word 0xff11131c

vida3_position_0: .word 0xff011330
vida3_position_1: .word 0xff111330
vida3_position_frame_anterior_0: .word 0xff011330
vida3_position_frame_anterior_1: .word 0xff111330

vidas_maximas: .word 3
vidas_atuais: .word 3

frames_sem_atualizar: .word 2
frames_sem_atualizar_count: .word 0

pontos: .word 0

NOTAS: .word 64,300,  64,300,  64,300,  60,300,  64,300,  67,300,  55,300,  60,300,  55,300,  52,300,  
	     57,300,  59,300,  58,300,  57,300,  55,300,  64,300,  67,300,  69,300,  65,300,  67,300,  
	     64,300,  60,300,  62,300,  59,300,  60,300,  55,300,  52,300,  57,300,  59,300,  58,300,  
	     57,300,  55,300,  64,300,  67,300,  69,300,  65,300,  67,300,  64,300,  60,300,  62,300,  
	     59,300,  67,300,  66,300,  65,300,  63,300,  64,300,  56,300,  57,300,  60,300,  57,300,  
	     60,300,  62,300,  67,300,  66,300,  65,300,  63,300,  64,300,  72,300,  72,300,  72,300,  
	     67,300,  66,300,  65,300,  63,300,  64,300,  56,300,  57,300,  60,300,  57,300,  60,300,  
	     62,300,  63,300,  62,300, 	60,300
	     
NUM_NOTAS: .word 74

.include "navefrontal.data"
.include "gameplay.data"
.include "bullet.data"
.include "menu.data"
.include "menu2.data"
.include "navio.data"
.include "vida.data"
.text
####################################################################################################
#												   #
#                       		    .text					           #
#          x precisa ser multiplo de 4                            	     	                                                   #
####################################################################################################

#li a1,48	#x
#li a2,220	#y
#li a3,0xff000000#pos inicial
#li a4,0xffffffff#cor
#la a5,vida#imagem
#jal image_position_calculator

####################################################################################################
#												   #
#                       		    KDMMIO					           #
#                                      	     	                                                   #
####################################################################################################
 la tp,KDInterrupt	# carrega em tp o endereço base das rotinas de Tratamento da Interrupção
 csrrw zero,5,tp 	# seta utvec (reg 5) para o endereço tp
 csrrsi zero,0,1 	# seta o bit de habilitação de interrupção global em ustatus (reg 0)
 li tp,0x100
 csrrw zero,4,tp	# habilita a interrupção do usuário

 li s1,0xFF200000	# Endereço de controle do KDMMIO
 li s0,0x02		# bit 1 habilita/desabilita a interrupção
 sw s0,0(s1)   		# Habilita interrupção do teclado	




####################################################################################################
#												   #
#                       		    MENU					           #
#                                      	     	                                                   #                                                   #
####################################################################################################

		li t6, space

		li s10,0xFF200604	# seleciona frame 0
		sw zero,0(s10)
	
		li s10,0xFF000000	# Frame0
		li s11,0xFF100000	# Frame1
		la t0,menu		# endereço da imagem
		lw t1,0(t0)		# número de linhas
		lw t2,4(t0)		# número de colunas
		li t3,0			# contador
		mul t4,t1,t2		# numero total de pixels
		addi t0,t0,8		# primeiro pixel da imagem
		
LOOP_MENU: 	beq t3,t4,OUT_LOOP_MENU	# Coloca a imagem no Frame0
		lw t5,0(t0)
		sw t5,0(s10)	
		addi t0,t0,4
		addi s10,s10,4
		addi t3,t3,1
		j LOOP_MENU
	
OUT_LOOP_MENU:
		
		la t0,menu2		# endereço da imagem
		lw t1,0(t0)		# número de linhas
		lw t2,4(t0)		# número de colunas
		li t3,0			# contador
		mul t4,t1,t2		# numero total de pixels
		addi t0,t0,8		# primeiro pixel da imagem
				
LOOP_MENU2: 	beq t3,t4,FORA_MENU	# Coloca a imagem no Frame0
		lw t5,0(t0)
		sw t5,0(s11)
		addi t0,t0,4
		addi s11,s11,4
		addi t3,t3,1
		j LOOP_MENU2
		
FORA_MENU:	li s10,0xFF200604	# Escolhe o Frame 0 ou 1
		li t2,0			# inicio Frame 0

SONG_MAIN:
		la s9,NUM_NOTAS		# define o endereço do número de notas
		lw s8,0(s9)		# le o numero de notas
		la s9,NOTAS		# define o endereço das notas
		li a4,0			# zera o contador de notas
		li a2,68		# define o instrumento
		li a3,50		# define o volume
		
LOOP_MENU3:
		beq s2, t6, GOTOMAIN
		
		beq a4,s8, SONG_FIM	# contador chegou no final? então  vá para FIM
		lw a0,0(s9)		# le o valor da nota
		lw a1,4(s9)		# le a duracao da nota
		li a7,31		# define a chamada de syscall
		ecall			# toca a nota
		mv a0,a1		# passa a duração da nota para a pausa
		li a7,32		# define a chamada de syscal 
		ecall			# realiza uma pausa de a0 ms
		addi s9,s9,8		# incrementa para o endereço da próxima nota
		addi a4,a4,1		# incrementa o contador de notas
		
  	  	sw t2,0(s10)		# seleciona a Frame t2
	 	xori t2,t2,0x001	# escolhe a outra frame
	 	
	 	## afeta no andamento da música ##
	  	#li a0,25		# pausa de 50m segundos
	  	#li a7,32
	  	#ecall	
	  	
	  	j LOOP_MENU3

SONG_FIM:
		li a0, 2000		# sleep 3s
		li a7, 32
		ecall
	
		j SONG_MAIN		# loop musica
		
GOTOMAIN:

li a0,60		# define a nota
li a1,3000		# define a duração da nota em ms
li a2,125		# define o instrumento
li a3,50		# define o volume
li a7,33		# define o syscall
ecall			# toca a nota

# Preenche a tela de preto
	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final 
	li t3,0x000		# cor preto
LOOP_FRAME1_PRETO:
 	beq t1,t2,FRAME2_PRETO	# Se for o último endereço então sai do loop
	sw t3,0(t1)		# escreve a word na memória VGA
	addi t1,t1,4		# soma 4 ao endereço
	j LOOP_FRAME1_PRETO	# volta a verificar

FRAME2_PRETO:
# Preenche a tela de preto
	li t1,0xFF100000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF112C00	# endereco final 
	li t3,0x000		# cor preto
LOOP_FRAME2_PRETO:
 	beq t1,t2,PRE_MAIN	# Se for o último endereço então sai do loop
	sw t3,0(t1)		# escreve a word na memória VGA
	addi t1,t1,4		# soma 4 ao endereço
	j LOOP_FRAME2_PRETO	# volta a verificar
		
####################################################################################################
#												   #
#                       		    MAIN					           #
#                                      	     	                                                   #
#   t6 = 1 indica fim de jogo e t6 = 0 game loop                                                   #
####################################################################################################

PRE_MAIN:

mv a0, zero
mv a1, zero
mv a2, zero
mv a3, zero
mv a4, zero
mv a7, zero
mv t0, zero
mv t1, zero
mv t2, zero
mv t3, zero
mv t4, zero
mv t5, zero
mv t6, zero
mv s2, zero
mv s8, zero
mv s9, zero
mv s10, zero
mv s11, zero
	
	la a1,background_position_0
	la a2,gameplay
	jal printa_imagem
	
	la a1,background_position_1
	la a2,gameplay
	jal printa_imagem




main:


addi sp,sp,-4
sw ra,0(sp)
li a6,0
jal imprime_numero_tela
lw ra,0(sp)
addi sp,sp,4

	mainloop:
	jal render_clear
	jal calculations
	mv t6,a3
	mv t6,zero
	bne t6,zero,fim
	jal render
	jal muda_frame

	beq t6,zero,mainloop

fim:	
li a7,10
ecall


####################################################################################################
#												   #
#                       		Muda_fRAME					           #
#                                      	     	                                                   #
#   alterna entre o frame 1 e o 0                                                  		   #
####################################################################################################
muda_frame:

li t0,0xFF200604
lw t1,0(t0)

beq t1,zero,set_frame_1

set_frame_0:
li t0,0xFF200604
li t1,0
sw t1,0(t0)
ret

set_frame_1:

li t0,0xFF200604
li t1,1
sw t1,0(t0)
ret
####################################################################################################
#												   #
#                       		 RETORNA_fRAME					           #
#                                      	     	                                                   #
#   indica qual o frame atual                                                 			   #
####################################################################################################

retorna_frame:

li t0,0xFF200604
lw t1,0(t0)


bnez t1,frame_1

frame_0:
mv  a1,zero
ret


frame_1:
li a1,1
ret


####################################################################################################
#												   #
#                       		  CALCULATIONS					           #
#                                      	     	                                                   #
#   s2 = ascii da tecla pressionada                                                   		   #
####################################################################################################

calculations:


li t0,left	
beq s2,t0,calculations_left

li t1,right	
beq s2,t1,calculations_right

li t2,shoot	
beq s2,t2,calculations_shoot

li t3,esc	
beq s2,t3,calculations_esc

calculations_continue:
j calculations_always

####################################################################################################
#												   #
#                       		  CALCULATIONS_LEFT					           #
#                                      	     	                                                   #
#  #Essa funcao e executada quando o left e pressionado                                          		   #
####################################################################################################

calculations_left:
addi sp,sp,-4
sw ra,0(sp)

la a0,L
li a7,4
ecall
####################################################################################################
#Nave										 #
####################################################################################################
##frame 1
la a1,nave_speed
lw a1,0(a1)
neg a1,a1

la t1,nave_position_1
lw t2,0(t1)

la t3,nave_position_frame_anterior_1
mv t4,t2
sw t4,0(t3)			  #Armazena a posicao anterior do objeto

add t2,t2,a1			  
sw t2,0(t1)			 #Calcula nova posicao da nave
##
##frame 0
la a1,nave_speed
lw a1,0(a1)
neg a1,a1

la t1,nave_position_0
lw t2,0(t1)

la t3,nave_position_frame_anterior_0 
mv t4,t2
sw t4,0(t3)			  #Armazena a posicao anterior do objeto

add t2,t2,a1			  
sw t2,0(t1)			 #Calcula nova posicao da nave


##

########
mv s2,zero		#reseta s2
lw ra,0(sp)
addi sp,sp,4
j calculations_continue


####################################################################################################
#												   #
#                       		  CALCULATIONS_RIGHT					           #
#                                      	     	                                                   #
#   #Essa funcao e executada quando o right e pressionado                                                  		   #
####################################################################################################

calculations_right:
addi sp,sp,-4
sw ra,0(sp)

la a0,R
li a7,4
ecall

####################################################################################################
#Nave										 #
####################################################################################################

##frame 1
la a1,nave_speed
lw a1,0(a1)

la t1,nave_position_1
lw t2,0(t1)

la t3,nave_position_frame_anterior_1
mv t4,t2
sw t4,0(t3)			  #Armazena a posicao anterior do objeto

add t2,t2,a1			  
sw t2,0(t1)			 #Calcula nova posicao da nave
##
##frame 0
la a1,nave_speed
lw a1,0(a1)

la t1,nave_position_0
lw t2,0(t1)

la t3,nave_position_frame_anterior_0 
mv t4,t2
sw t4,0(t3)			  #Armazena a posicao anterior do objeto

add t2,t2,a1			  
sw t2,0(t1)			 #Calcula nova posicao da nave


##

########
mv s2,zero		#reseta s2
lw ra,0(sp)
addi sp,sp,4
j calculations_continue


####################################################################################################
#												   #
#                       		  CALCULATIONS_SHOOT					           #
#                                      	     	                                                   #
#    #Essa funcao e executada quando o shoot e pressionado                                                 		   #
####################################################################################################

calculations_shoot:


la a0,S
li a7,4
ecall
####################################################################################################
#Bala		Marca a bala como viva ,seta a posicao inicial do objeto e seta os sons							 #
####################################################################################################
la t1,bullet_alive
lw s3,0(t1)
bnez s3,calculations_shoot_end # Se a bala ja estiver viva,nao faz nada
li t2,1
sw t2,0(t1)#Marca a bala como viva
#frame0
la t3,nave_position_0
lw t4,0(t3)	#A posicao da nave
addi t4,t4,8	#Centralizando a bala na nave
la t5,bullet_position_0
lw t6,0(t5)
la s3,bullet_position_frame_anterior_0 
sw t6,0(s3)			  #Armazena a posicao anterior do objeto
sw t4,0(t5) #Armaze a nova posicao do objeto.A posicao inicial da bala e a mesma da nave

#
#frame1
la t3,nave_position_1
lw t4,0(t3)	#A posicao da nave
addi t4,t4,8	#Centralizando a bala na nave
la t5,bullet_position_1
lw t6,0(t5)
la s3,bullet_position_frame_anterior_1
sw t6,0(s3)			  #Armazena a posicao anterior do objeto
sw t4,0(t5) #Armaze a nova posicao do objeto.A posicao inicial da bala e a mesma da nave
sw t4,0(t5) #A posicao inicial da bala e a mesma da nave
#
##

### som do tiro
#li a0,20		# define a nota
### duração da nota afeta na mobilidade da nave
#li a1,150		# define a duração da nota em ms
#li a2,120		# define o instrumento
#li a3,100		# define o volume
#li a7,33		# define o syscall
#ecall			# toca a nota
###

### reseta regs
mv a0, zero
mv a1, zero
mv a2, zero
mv a3, zero
mv a7, zero
###

calculations_shoot_end:


####################################################################################################
#Navio	Marca o navio como vivo e seta a posicao inicial do objeto							 #
###################################################################################################

la t1,navio_alive
lw s3,0(t1)
bnez s3,calculations_navio_end # Se o navio  ja estiver vivo,nao faz nada
li t2,1
sw t2,0(t1)#Marca o navio como vivo



#frame0
li t4,0xff000400
la t5,navio_position_0
sw t4,0(t5) #Armaze a nova posicao do objeto

la t3,navio_position_frame_anterior_0
sw t4,0(t3)			  #Armazena a posicao anterior do objeto
#
#frame1
li t4,0xff100400
la t5,navio_position_1
sw t4,0(t5) #Armaze a nova posicao do objeto

la t3,navio_position_frame_anterior_0
sw t4,0(t3)			  #Armazena a posicao anterior do objeto
#
calculations_navio_end:
mv s2,zero		#reseta s2
j calculations_continue


####################################################################################################
#												   #
#                       		  CALCULATIONS_ESC					           #
#                                      	     	                                                   #
# #Essa funcao e executada quando o esc e pressionado                                                    		   #
###################################################################################################


calculations_esc:

la a0,E
li a7,4
ecall
mv s2,zero		#reseta s2

li a3,1	#Fim do programa
ret			#retorna para main


####################################################################################################
#												   #
#                       		  CALCULATIONS_ALWAYS					           #
#                                      	     	                                                   #
#  #Essa funcao e executada em todos os frames                                                  		   #
####################################################################################################
calculations_always:

addi sp,sp,-4
sw ra,0(sp)

####################################################################################################
#Contador de frames									 #
####################################################################################################

la t0,frames_sem_atualizar_count
lw t1,0(t0)
addi t1,t1,1


la t2,frames_sem_atualizar
lw t3,0(t2)

bgt t1,t3,frame_counter_restart
sw t1,0(t0)
j frame_counter_continue
frame_counter_restart:
sw zero,0(t0)
frame_counter_continue:

####################################################################################################
#Navio.Move o objeto ,armazena a posicao do frame anterior,do frame atual e verifica se o objeto saiu da tela para mata-lo									 #
####################################################################################################
la t0,navio_alive
lw t1,0(t0)

la s4,frames_sem_atualizar_count
lw s4,0(s4)

beqz t1,final_navio #Se o navio esta morto, vai pro fim da funcao
bnez s4,final_navio
li t2,bitmap_largura	

#frame1
la t3,navio_position_1
lw t4,0(t3) #A posicao em que a bala esta
la s4,navio_position_frame_anterior_1
sw t4,0(s4)	

add t5,t4,t2
la s5,navio_speed
lw s5,0(s5)
add t5,t5,s5	#Velocidade no eixo x

li s3,0xff10e600 # limite inferior da tela noe frame 1
#bgt t5,s3,kill_navio	#verifica se o objeto saiu da tela
sw t5,0(t3)

##
#frame 0
la t3,navio_position_0
lw t4,0(t3) #A posicao em que a bala esta
la s4,navio_position_frame_anterior_0
sw t4,0(s4)	

add t5,t4,t2
la s5,navio_speed
lw s5,0(s5)
add t5,t5,s5	#Velocidade no eixo x


li s3,0xff00e600 # limite inferior da tela noe frame 1
bgt t5,s3,kill_navio
sw t5,0(t3)
j final_navio
##
kill_navio:
li s4,0#Se chegou aqui e porque a bala saiu da tela
sw s4,(t0) #mata a bala
##

final_navio:

####################################################################################################
#Bullet										 #
####################################################################################################
la t0,bullet_alive
lw t1,0(t0)

beqz t1,final_bullet #Se a bala esta morta, vai pro fim da funcao
li t2,bitmap_largura	
slli t2,t2,2	#Sera utilizado como velocidade da bala

##frame1
la t3,bullet_position_1
lw t4,0(t3) #A posicao em que a bala esta
la s4,bullet_position_frame_anterior_1 
sw t4,0(s4)			  #Armazena a posicao anterior do objeto
sub t5,t4,t2
li s3,0xff000000
blt t5,s3,kill_bullet
sw t5,0(t3)
##
##frame 0
la t3,bullet_position_0
lw t4,0(t3) #A posicao em que a bala esta
la s4,bullet_position_frame_anterior_0 
sw t4,0(s4)			  #Armazena a posicao anterior do objeto
sub t5,t4,t2
li s3,0xff000000
blt t5,s3,kill_bullet
sw t5,0(t3)
##
j final_bullet
kill_bullet:
li s4,0#Se chegou aqui e porque a bala saiu da tela
sw s4,(t0) #mata a bala
##
final_bullet:



####################################################################################################
####################################################################################################

lw ra,0(sp)
addi sp,sp,4
ret	
####################################################################################################
#												   #
#                       		  RENDER					           #
#                                      	     	                                                   #
####################################################################################################

render:
	
	
	addi sp,sp,-4
	sw ra,0(sp)
	

	jal retorna_frame
	beqz a1,modificar_frame1	#Se o frame atual for o frame 0, o frame 1 deve ser modificado

	modificar_frame0:
####################################################################################################
#Navio									 #
##################################################################################################
	
	la t1,navio_alive

	lw t2,0(t1)

	
	beqz t2,end_navio_render_0#Se a bala ja estiver morta, ela nao e renderizada
	li a7,1

	la a1,navio_position_0
	la a2,navio
	la a5,navio_position_frame_anterior_0
	jal printa_imagem
	end_navio_render_0:
	##

####################################################################################################
#Nave										 #
##################################################################################################
	la a1,nave_position_0
	la a2,navefrontal
	la a5,nave_position_frame_anterior_0
	jal printa_imagem
	##
####################################################################################################
#Bala										 #
##################################################################################################	
	##Bala
	la t1,bullet_alive
	lw t2,0(t1)
	beqz t2,end_bala_render_0#Se a bala ja estiver morta, ela nao e renderizada
	la a1,bullet_position_0
	la a2,bullet
	la a5,bullet_position_frame_anterior_0
	jal printa_imagem
	end_bala_render_0:
	
	##
	
	
la t0,vidas_atuais
lw t0,0(t0)
beqz t0,frame0_fim_vidas	#Se a quantidade de vidas for 0, nao mostra nenhuma

####################################################################################################
#Vida1									 #
##################################################################################################
	la a1,vida1_position_0
	la a2,vida
	la a5,vida1_position_frame_anterior_0
	jal printa_imagem
	##
li t1,1
beq t0,t1,frame0_fim_vidas	#Se a quantidade de vidas for 1 , msotra apenas 1 e sai
####################################################################################################
#Vida2								 #
##################################################################################################
	la a1,vida2_position_0
	la a2,vida
	la a5,vida2_position_frame_anterior_0
	jal printa_imagem
	##
li t1,2
beq t0,t1,frame0_fim_vidas	#Se a quantidade de vidas for 2 , msotra apenas 2 e sai
####################################################################################################
#Vida3								 #
##################################################################################################
	la a1,vida3_position_0
	la a2,vida
	la a5,vida3_position_frame_anterior_0
	jal printa_imagem
	##
####################################################################################################
##################################################################################################
frame0_fim_vidas:


	final_frame_0:
	lw ra,0(sp)
	addi sp,sp,4
	ret


	modificar_frame1:
	####################################################################################################
#Navio										 #
##################################################################################################	
	la t1,navio_alive
	lw t2,0(t1)
	beqz t2,	end_navio_render_1#Se  ja o navaio estiver morto, ele n e renderizado
	la a1,navio_position_1
	la a2,navio
	la a5,navio_position_frame_anterior_0
	jal printa_imagem
	end_navio_render_1:
	##

####################################################################################################
#Nave										 #
##################################################################################################
	la a1,nave_position_1
	la a2,navefrontal
	la a5,nave_position_frame_anterior_1
	jal printa_imagem

	##
	
	##
####################################################################################################
#Bala										 #
##################################################################################################
	la t1,bullet_alive
	lw t2,0(t1)
	beqz t2,end_bala_render_1#Se a bala ja estiver morta, ela nao e renderizada
	la a1,bullet_position_1
	la a2,bullet
	la a5,bullet_position_frame_anterior_0
	jal printa_imagem
	end_bala_render_1:
	##
la t0,vidas_atuais
lw t0,0(t0)
beqz t0,frame1_fim_vidas	#Se a quantidade de vidas for 0, nao mostra stra ne
####################################################################################################
#Vida1									 #
##################################################################################################
	la a1,vida1_position_1
	la a2,vida
	la a5,vida1_position_frame_anterior_1
	jal printa_imagem
	##
li t1,1
beq t0,t1,frame1_fim_vidas	#Se a quantidade de vidas for 1 , msotra apenas 1 e sai
####################################################################################################
#Vida2								 #
##################################################################################################
	la a1,vida2_position_1
	la a2,vida
	la a5,vida2_position_frame_anterior_1
	jal printa_imagem
	##
li t1,2
beq t0,t1, frame1_fim_vidas	#Se a quantidade de vidas for 1 , msotra apenas 1 e sai
####################################################################################################
#Vida3								 #
##################################################################################################
	la a1,vida3_position_1
	la a2,vida
	la a5,vida3_position_frame_anterior_1
	jal printa_imagem
	##
frame1_fim_vidas:
##################################################################################################
##################################################################################################
	final_frame_1:
	
	lw ra,0(sp)
	addi sp,sp,4
	ret
	


	
####################################################################################################
#												   #
#                       		  RENDER_Clear					           #
#                                      	     	                                                   #
####################################################################################################

render_clear:

	addi sp,sp,-4
	sw ra,0(sp)
	
	jal retorna_frame
	beqz a1,clear_frame1	#Se o frame atual for o frame 0, o frame 1 deve ser modificado
	
	clear_frame0:
	
		#li s8,0xA4A4A4A4
	#li s8,0x89898989		#background colour
	
####################################################################################################
#Nave										 #
##################################################################################################
	la a1,nave_position_frame_anterior_0
	la a2,navefrontal
	li a5,0x89898989
	jal clear_objects
	#
####################################################################################################
#Bala									 #
##################################################################################################	
	#bala
	la a1,bullet_position_frame_anterior_0
	la a2,navefrontal
	li a5,0x89898989
	jal clear_objects
	#
####################################################################################################
#navio									 #
##################################################################################################	
	la a1,navio_position_frame_anterior_0
	la a2,navio
	li a5,0x89898989
	jal clear_objects
	#	
la t0,vidas_atuais
lw t0,0(t0)
li t1 ,3
bge t0,t1,frame0_render_clear_vida_end #Se o jogador ainda nao perdue nenhuma vida, as vidas nao somem
li t1 ,2
bge t0,t1,frame0_render_clear_vida_3 #Se o jogador perdeu uma vida, apenas a vida de numero 3 e retirada
li t1 ,1
bge t0,t1,frame0_render_clear_vida_2_3 #Se o jogador perdeu duas vidas, apenas as vidas de numero  2 e 3 sao retiradas
li t1 ,1
bge t0,t1,frame0_render_clear_vida_1_2_3 #Se o jogador perdeu as 3 vidas, todas as vidas sao retiradas

frame0_render_clear_vida_1_2_3:
####################################################################################################
#Vida1									 #
##################################################################################################
	la a1,vida1_position_frame_anterior_0
	la a2,vida
	li a5,0xA4A4A4A4
	jal clear_objects
	##
	


frame0_render_clear_vida_2_3:
####################################################################################################
#Vida2								 #
##################################################################################################
	la a1,vida2_position_frame_anterior_0
	la a2,vida
	li a5,0xA4A4A4A4
	jal clear_objects
	##

frame0_render_clear_vida_3:
####################################################################################################
#Vida3								 #
##################################################################################################
	la a1,vida3_position_frame_anterior_0
	la a2,vida
	li a5,0xA4A4A4A4
	jal clear_objects
	##
frame0_render_clear_vida_end:

####################################################################################################
#################################################################################################	
	lw ra,0(sp)
	addi sp,sp,4
	ret

	clear_frame1:
####################################################################################################
#Nave									 #
##################################################################################################
	la a1,nave_position_frame_anterior_1
	la a2,navefrontal
	li a5,0x89898989
	jal clear_objects
	#
####################################################################################################
#Bala									 #
##################################################################################################
	la a1,bullet_position_frame_anterior_1
	la a2,navefrontal
	li a5,0x89898989
	jal clear_objects
####################################################################################################
#navio									 #
##################################################################################################	
	la a1,navio_position_frame_anterior_1
	la a2,navio
	li a5,0x89898989
	jal clear_objects
	#	
	
la t0,vidas_atuais
lw t0,0(t0)
li t1 ,3
bge t0,t1,frame1_render_clear_vida_end #Se o jogador ainda nao perdue nenhuma vida, as vidas nao somem
li t1 ,2
bge t0,t1,frame1_render_clear_vida_3 #Se o jogador perdeu uma vida, apenas a vida de numero 3 e retirada
li t1 ,1
bge t0,t1,frame1_render_clear_vida_2_3 #Se o jogador perdeu duas vidas, apenas as vidas de numero  2 e 3 sao retiradas
li t1 ,1
bge t0,t1,frame1_render_clear_vida_1_2_3 #Se o jogador perdeu as 3 vidas, todas as vidas sao retiradas

frame1_render_clear_vida_1_2_3:
####################################################################################################
#Vida1									 #
##################################################################################################
	la a1,vida1_position_frame_anterior_1
	la a2,vida
	li a5,0xA4A4A4A4
	jal clear_objects
	##
frame1_render_clear_vida_2_3:
####################################################################################################
#Vida2								 #
##################################################################################################
	la a1,vida2_position_frame_anterior_1
	la a2,vida
	li a5,0xA4A4A4A4
	jal clear_objects
	##
frame1_render_clear_vida_3:
####################################################################################################
#Vida3								 #
##################################################################################################
	la a1,vida3_position_frame_anterior_1
	la a2,vida
	li a5,0xA4A4A4A4
	jal clear_objects
	##
frame1_render_clear_vida_end:
####################################################################################################
##################################################################################################
	lw ra,0(sp)
	addi sp,sp,4
	ret
	
	
	
	
	
####################################################################################################
#												   #
#                       		    wall_collision					           #
#                                      	     	                                                   #
#   a1 = label da posicao da imagem	 , a2 = .data da imagem   a5 = posicao_anterior
#Detecta se o objeto passado como parametro colidiu com a parede e entao trata a colisao             #
###################################################################################################	
wall_collision:

	addi sp,sp,-48
	sw t0,0(sp)
	sw t1,4(sp)
	sw t2,8(sp)
	sw t3,12(sp)
	sw t4,16(sp)
	sw t5,20(sp)
	sw t6,24(sp)
	sw s3,28(sp)
	sw s4,32(sp)
	sw s5,36(sp)
	sw s6,40(sp)
	sw s7,44(sp)
	
	la s8,navefrontal
	la s9,bullet
	la s10,navio
	
	beq a2,s8,wall_collision_nave
	beq a2,s9,wall_collision_bullet
	beq a2,s10,wall_collision_navio


wall_collision_nave:

#Colision###########################################################################################################
mv t0,a1 #label da posicao da imagem
lw t1,0(t0) #posicao da imagem,top left

li s8,0xff000000		#Evita que ocorra um overflow para imagens que comecam no inicio do bitmap
beq t1,s8, colisao_nao_ocorreu_nave
li s8,0xff100000		#Evita que ocorra um overflow para imagens que comecam no inicio do bitmap
beq t1,s8, colisao_nao_ocorreu_nave



mv t2,a2	#endereco do .data da imagem
lw t3,0(t2)	#largura da imagem
add t4,t1,t3	#top right = top left + largura da imagem

li t5,8 #velocidade do objeto

sub t6,t1,t5	#top left - 16
add s3,t4,t5	#top right + 16
lw s4,0(t6)	# pixel da posicao top left - 16
lw s5,0(s3)	#pixel da posicao top right + 16

li s6,0x63636363 # Cor da parede

colisao_parede_esquerda_nave:
bne s4,s6,colisao_parede_direita_nave
mv s7,t1	#posicao top left
add s7,s7,t5	#retorna a posicao do objeto para o valor anterior a colisao ocorrer
sw s7,0(t0)	#armazena a nova posicao do objeto
sw s7,0(a5)	#armazena a nova posicao do objeto na variavel posicao_anterior
li a6,1
j end_wall_collision_nave
colisao_parede_direita_nave:
bne s5,s6,colisao_nao_ocorreu_nave
mv s7,t1	#posicao top left
sub s7,s7,t5	#retorna a posicao do objeto para o valor anterior a colisao ocorrer
sw s7,0(t0)	#armazena a nova posicao do objeto
sw s7,0(a5)	#armazena a nova posicao do objeto na variavel posicao_anterior
li a6,1
j end_wall_collision_nave

colisao_nao_ocorreu_nave:
li a6,0
end_wall_collision_nave:
#############################################################################################3
j wall_collision_type_end

wall_collision_bullet:
li a6,0
j wall_collision_type_end

wall_collision_navio:
#Colision###########################################################################################################
mv t0,a1 #label da posicao da imagem
lw t1,0(t0) #posicao da imagem,top left

li s8,0xff000000		#Evita que ocorra um overflow para imagens que comecam no inicio do bitmap
beq t1,s8, colisao_nao_ocorreu_navio
li s8,0xff100000		#Evita que ocorra um overflow para imagens que comecam no inicio do bitmap
beq t1,s8, colisao_nao_ocorreu_navio



mv t2,a2	#endereco do .data da imagem
lw t3,0(t2)	#largura da imagem
add t4,t1,t3	#top right = top left + largura da imagem

li t5,4 #velocidade do objeto

sub t6,t1,t5	#top left - 16
add s3,t4,t5	#top right + 16
lw s4,0(t6)	# pixel da posicao top left - 16
lw s5,0(s3)	#pixel da posicao top right + 16

li s6,0x63636363 # Cor da parede

colisao_parede_esquerda_navio:
bne s4,s6,colisao_parede_direita_navio
mv s7,t1	#posicao top left
add s7,s7,t5	#retorna a posicao do objeto para o valor anterior a colisao ocorrer
sw s7,0(t0)	#armazena a nova posicao do objeto
sw s7,0(a5)	#armazena a nova posicao do objeto na variavel posicao_anterior
li a6,1
la s8,navio_speed
lw s9,0(s9)
neg s9,s9
li s9,4
sw s9,0(s8)

j end_wall_collision_navio
colisao_parede_direita_navio:
bne s5,s6,colisao_nao_ocorreu_navio
mv s7,t1	#posicao top left
sub s7,s7,t5	#retorna a posicao do objeto para o valor anterior a colisao ocorrer
sw s7,0(t0)	#armazena a nova posicao do objeto
sw s7,0(a5)	#armazena a nova posicao do objeto na variavel posicao_anterior
li a6,1
la s8,navio_speed
lw s9,0(s9)
neg s9,s9
li s9,-4
sw s9,0(s8)
j end_wall_collision_navio

colisao_nao_ocorreu_navio:
li a6,0
end_wall_collision_navio:
#############################################################################################3
j wall_collision_type_end

wall_collision_type_end:



	lw t0,0(sp)
	lw t1,4(sp)
	lw t2,8(sp)
	lw t3,12(sp)
	lw t4,16(sp)
	lw t5,20(sp)
	lw t6,24(sp)
	lw s3,28(sp)
	lw s4,32(sp)
	lw s5,36(sp)
	lw s6,40(sp)
	lw s7,44(sp)
	addi sp,sp,48
ret


####################################################################################################
#												   #
#                       		    bullet_collision					           #
#                                      	     	                                                   #
#   a1 = label da posicao da imagem	 , a2 = .data da imagem   a5 = posicao_anterior
#Detecta se o objeto passado como parametro colidiu com a parede e entao trata a colisao             #
###################################################################################################
bullet_collision:

	addi sp,sp,-48
	sw t0,0(sp)
	sw t1,4(sp)
	sw t2,8(sp)
	sw t3,12(sp)
	sw t4,16(sp)
	sw t5,20(sp)
	sw t6,24(sp)
	sw s3,28(sp)
	sw s4,32(sp)
	sw s5,36(sp)
	sw s6,40(sp)
	sw s7,44(sp)

	la t0,bullet
	la t1,navefrontal
	la t2,navio
	mv t3,zero
	mv t4,zero
	mv t5,zero
	mv t6,zero
	
	
	bne a2,t0,bullet_collision_end	#Se o objeto atual nao for a bala,vai pro frim da funcao
	
	mv s7,a1		
	lw s7,0(s7)	#posicao top left da imagem
	lw s4,0(s7)	#pixel da posicao top left da imagem
	li s6,bitmap_largura
	li s5,0x14141414 #cor da base do navio
	beq s4,s5,detect_bullet_collision_with_navio_detected
	sub s4,s4,s6
	li s5,0x14141414 #cor da base do navio
	beq s4,s5,detect_bullet_collision_with_navio_detected

	mv s7,a1		
	lw s7,0(s7)	#posicao top left da imagem
	lw s3,0(a2)
	lw s4,0(s7)	#pixel da posicao top left da imagem
	add s4,s4,s3
	li s6,bitmap_largura
	li s5,0x14141414 #cor da base do navio
	beq s4,s5,detect_bullet_collision_with_navio_detected
	sub s4,s4,s6
	li s5,0x14141414 #cor da base do navio
	beq s4,s5,detect_bullet_collision_with_navio_detected


	j detect_bullet_collision_with_navio_end
	detect_bullet_collision_with_navio_detected:
	


la s3,pontos
lw s7,0(s3)
addi s7,s7,10
sw s7,0(s3)

addi sp,sp,-4
sw ra,0(sp)
mv a6,s7
jal imprime_numero_tela
lw ra,0(sp)
addi sp,sp,4
	
	li a7,1
	li a0,1
	ecall
	la s7,navio_alive
	li s3,0
	sw s3,0(s7)
	la s7,bullet_alive
	li s3,0
	sw s3,0(s7)
	
	detect_bullet_collision_with_navio_end:





	bullet_collision_end:
	
	lw t0,0(sp)
	lw t1,4(sp)
	lw t2,8(sp)
	lw t3,12(sp)
	lw t4,16(sp)
	lw t5,20(sp)
	lw t6,24(sp)
	lw s3,28(sp)
	lw s4,32(sp)
	lw s5,36(sp)
	lw s6,40(sp)
	lw s7,44(sp)
	addi sp,sp,48
ret


####################################################################################################
#												   #
#                       		    nave_collision					           #
#                                      	     	                                                   #
#   a1 = label da posicao da imagem	 , a2 = .data da imagem   a5 = posicao_anterior
#Detecta se o objeto passado como parametro colidiu com a parede e entao trata a colisao             #
###################################################################################################
nave_collision:

	addi sp,sp,-48
	sw t0,0(sp)
	sw t1,4(sp)
	sw t2,8(sp)
	sw t3,12(sp)
	sw t4,16(sp)
	sw t5,20(sp)
	sw t6,24(sp)
	sw s3,28(sp)
	sw s4,32(sp)
	sw s5,36(sp)
	sw s6,40(sp)
	sw s7,44(sp)

	la t0,bullet
	la t1,navefrontal
	la t2,navio
	mv t3,zero
	mv t4,zero
	mv t5,zero
	mv t6,zero
	
	
	bne a2,t1,bullet_collision_end	#Se o objeto atual nao for a bala,vai pro frim da funcao
	
	mv s7,a1		
	lw s7,0(s7)	#posicao top left da imagem
	lw s4,0(s7)	#pixel da posicao top left da imagem
	li s6,bitmap_largura
	li s5,0x14141414 #cor da base do navio
	beq s4,s5,detect_nave_collision_with_navio_detected
	sub s4,s4,s6
	li s5,0x14141414 #cor da base do navio
	beq s4,s5,detect_nave_collision_with_navio_detected

	mv s7,a1		
	lw s7,0(s7)	#posicao top left da imagem
	lw s3,0(a2)
	lw s4,0(s7)	#pixel da posicao top left da imagem
	add s4,s4,s3
	li s6,bitmap_largura
	li s5,0x14141414 #cor da base do navio
	beq s4,s5,detect_nave_collision_with_navio_detected
	sub s4,s4,s6
	li s5,0x14141414 #cor da base do navio
	beq s4,s5,detect_nave_collision_with_navio_detected


	j detect_nave_collision_with_navio_end
	detect_nave_collision_with_navio_detected:

	la s7,navio_alive	#mata o navio
	li s3,0
	sw s3,0(s7)
	
	la s7,vidas_atuais
	lw s8,0(s7)
	addi s8,s8,-1
	sw s8,0(s7)
	
	li a7,1
	mv a0,s8
	ecall
	
	detect_nave_collision_with_navio_end:





	nave_collision_end:
	
	lw t0,0(sp)
	lw t1,4(sp)
	lw t2,8(sp)
	lw t3,12(sp)
	lw t4,16(sp)
	lw t5,20(sp)
	lw t6,24(sp)
	lw s3,28(sp)
	lw s4,32(sp)
	lw s5,36(sp)
	lw s6,40(sp)
	lw s7,44(sp)
	addi sp,sp,48
ret



####################################################################################################
#												   #
#                       		    PRINTA_IMAGEM					           #
#                                      	     	                                                   #
#   a1 = label da posicao da imagem	 , a2 = .data da imagem  a5= label da posicao do frame anterior                             #
####################################################################################################

printa_imagem:
	addi sp,sp,-48
	sw t0,0(sp)
	sw t1,4(sp)
	sw t2,8(sp)
	sw t3,12(sp)
	sw t4,16(sp)
	sw t5,20(sp)
	sw t6,24(sp)
	sw s3,28(sp)
	sw s4,32(sp)
	sw s5,36(sp)
	sw s6,40(sp)
	sw ra,44(sp)
	
	mv t1,zero	
	mv t2,zero	
	mv t3,a1    		#endereco do label da posicao da imagem	
	lw t4,0(t3) 		#posicao do bitmap em que a imagem sera impressa
	mv t5,a2   		#endereco do .data da imagem
	lw s3,0(t5)	  	#largura imagem
	lw s4,4(t5)	  	#altura imagem
	addi t5,t5,8		# primeiro pixel depois das informações de nlin ncol
	mul s5,s3,s4		#Quantidade de bytes na imagem, largura x altura
	li s6,bitmap_largura     #largura bitmap
	li s7,bitmap_altura	#altura bitmap

	jal bullet_collision
	jal nave_collision
	jal wall_collision
	bnez a6,end_image_print # Se a1 != 0 , ocorrera uma coliscao com a parade no proximo frame
	

	image_print_loop:
	
	lw s8,0(t5)		# le um conjunto de 4 pixels : word
	
	#li a7,1
	#mv a0,s8
	#ecall
	#li a7,10
	#ecall

	li s9,0x00000000		#cor da transparencia	
	beq s8,s9,pula_pixel_transparente
	sw s8,0(t4)		# escreve a word na memória VGA
	
	pula_pixel_transparente:
	addi t4,t4,4		# soma 4 ao endereço da VGA
	addi t5,t5,4		# soma 4 ao endereco da imagem
	
	add t1,t1,4		#Contador para verificar se a quantidade maxima de words da imagem ja foi lida
	add t2,t2,4		#Contador para verificar se a quantidade maxima de bytes por linha ja foi preenchida
	
		
	bge t2,s3,image_print_pula_linha	#verifica se a largura maxima da linha para essa imagem ja foi preenchida
	image_print_pula_linha_return:
	
	blt t1,s5,image_print_loop 	# Se for o último endereço então sai do loop
	
	end_image_print:
	lw t0,0(sp)
	lw t1,4(sp)
	lw t2,8(sp)
	lw t3,12(sp)
	lw t4,16(sp)
	lw t5,20(sp)
	lw t6,24(sp)
	lw s3,28(sp)
	lw s4,32(sp)
	lw s5,36(sp)
	lw s6,40(sp)
	lw ra,44(sp)
	addi sp,sp,48
	ret

image_print_pula_linha:

add t4,t4,s6	#Soma a posicao atual ao comprimento da tela,isso faz com que a linha seja pulada
sub t4,t4,s3	#Subtrai da posicao atual a largura da imagem
mv t2,zero

j image_print_pula_linha_return


####################################################################################################
#												   #
#                       		    CLEAR_OBJECTS					   #
#                                      	     	                                                   #
#   a1 = label da posicao da imagem	 , a2 = .data da imagem  ,a5=background colour                                  #
####################################################################################################

clear_objects:
	addi sp,sp,-48
	sw t0,0(sp)
	sw t1,4(sp)
	sw t2,8(sp)
	sw t3,12(sp)
	sw t4,16(sp)
	sw t5,20(sp)
	sw t6,24(sp)
	sw s3,28(sp)
	sw s4,32(sp)
	sw s5,36(sp)
	sw s6,40(sp)
	sw s7,40(sp)
	
	mv t1,zero	
	mv t2,zero	
	mv t3,a1    		#endereco do label da posicao da imagem	
	lw t4,0(t3) 		#posicao do bitmap em que a imagem sera impressa
	mv t5,a2   		#endereco do .data da imagem
	lw s3,0(t5)	  	#largura imagem
	lw s4,4(t5)	  	#altura imagem
	addi t5,t5,8		# primeiro pixel depois das informações de nlin ncol
	mul s5,s3,s4		#Quantidade de bytes na imagem, largura x altura
	li s6,bitmap_largura     #largura bitmap
	li s7,bitmap_altura	#altura bitmap
	
	mv s8,a5 #background colour

		
	clear_objects_loop:
	#li s8,0xA4A4A4A4
	#li s8,0x89898989		#background colour
	
	sw s8,0(t4)		# escreve a word na memória VGA

	addi t4,t4,4		# soma 4 ao endereço da VGA
	
	add t1,t1,4		#Contador para verificar se a quantidade maxima de words da imagem ja foi lida
	add t2,t2,4		#Contador para verificar se a quantidade maxima de bytes por linha ja foi preenchida
	
	bge t2,s3,clear_objects_pula_linha	#verifica se a largura maxima da linha para essa imagem ja foi preenchida
	clear_objects_pula_linha_return:
	
	blt t1,s5,clear_objects_loop 	# Se for o último endereço então sai do loop
	
	lw t0,0(sp)
	lw t1,4(sp)
	lw t2,8(sp)
	lw t3,12(sp)
	lw t4,16(sp)
	lw t5,20(sp)
	lw t6,24(sp)
	lw s3,28(sp)
	lw s4,32(sp)
	lw s5,36(sp)
	lw s6,40(sp)
	lw s7,40(sp)
	addi sp,sp,48
	ret

clear_objects_pula_linha:

add t4,t4,s6	#Soma a posicao atual ao comprimento da tela,isso faz com que a linha seja pulada
sub t4,t4,s3	#Subtrai da posicao atual a largura da imagem
mv t2,zero

j clear_objects_pula_linha_return

####################################################################################################
#												   #
#                             Image_position_calculator					#
# a1= valor para x
#,a2= valor para y    				    	                  #        
#,a3= frame escolhido = 1 ou 0      				    	                  #   
#,a4= cor de preenchimento         				    	                  #   
#,a5= endereco do .data da imagem         				    	                  #                     #
####################################################################################################

image_position_calculator:


#li a1,160
#li a2,120
#li a3,0xff000000
#li a4,0xffffffff
#la a5,navefrontal



lw s4,0(a5) #largura da imagem
srli s5,s4,1#Obtem o valor  da largura da imagem/2 para centralizar a imagem
mv t1,a1	  #ponto x inicial
mv t2,a2	  #ponto y inicial


li t3,bitmap_largura      	  #largura bitmap
li t4,bitmap_altura	  #altura bitmap

mv t5,a3 #frame 0

mv s3,a4 #branco

mul t6,t2,t3	#posicao y * largura bitmap
add t6,t6,t1	#(posicao y * largura bitmap) + posicao x
add t6,t6,t5	#(posicao y * largura bitmap) + posicao x + posicao inicial


li a7,1
mv a0,t6
ecall

li a7,10
ecall

ret


imprime_numero_tela:

	addi sp,sp,-32
	sw a0,0(sp)
	sw a1,4(sp)
	sw a2,8(sp)
	sw a3,12(sp)
	sw a4,16(sp)
	sw a5,20(sp)
	sw a6,24(sp)
	sw a7,28(sp)




la tp,KDInterrupt	# carrega em tp o endereço base das rotinas de Tratamento da Interrupção
 csrrw zero,5,tp 	# seta utvec (reg 5) para o endereço tp
 csrrsi zero,0,1 	# seta o bit de habilitação de interrupção global em ustatus (reg 0)
 li tp,0x100
 csrrw zero,4,tp	# habilita a interrupção do usuário

 li s1,0xFF200000	# Endereço de controle do KDMMIO
 li s0,0x01		# bit 1 habilita/desabilita a interrupção
 sw s0,0(s1)   		# Habilita interrupção do teclado	o usu
 
 	la tp,exceptionHandling	# carrega em tp o endereço base das rotinas do sistema ECALL
 	csrrw zero,5,tp 	# seta utvec (reg 5) para o endereço tp
 	csrrsi zero,0,1 	# seta o bit de habilitação de interrupção em ustatus (reg 0)


li a7,101
mv a0 ,a6
li a1 260
li a2 220
li a3 0x0000A4fa
li a4 0
ecall

li a7,101
mv a0 ,a6
li a1 260
li a2 220
li a3 0x0000A4fa
li a4 1
ecall

 la tp,KDInterrupt	# carrega em tp o endereço base das rotinas de Tratamento da Interrupção
 csrrw zero,5,tp 	# seta utvec (reg 5) para o endereço tp
 csrrsi zero,0,1 	# seta o bit de habilitação de interrupção global em ustatus (reg 0)
 li tp,0x100
 csrrw zero,4,tp	# habilita a interrupção do usuário

 li s1,0xFF200000	# Endereço de controle do KDMMIO
 li s0,0x02		# bit 1 habilita/desabilita a interrupção
 sw s0,0(s1)   		# Habilita interrupção do teclado	o usu
 
 
 	
	lw a0,0(sp)
	lw a1,4(sp)
	lw a2,8(sp)
	lw a3,12(sp)
	lw a4,16(sp)
	lw a5,20(sp)
	lw a6,24(sp)
	lw a7,28(sp)
	addi sp,sp,32

ret


####################################################################################################
#												   #
#                             ROTINA DE TRATAMENTO KDMMIO				           #
#                                      	     	                                                   #
####################################################################################################

KDInterrupt:
		csrrci zero,0,1 	# clear o bit de habilitação de interrupção global em ustatus (reg 0)
  		lw s2,4(s1)  			# le a tecla
		#sw s2,12(s1) 			# escreve no display

		csrrsi zero,0,0x10 	# seta o bit de habilitação de interrupção em ustatus 
		uret
		
.include "SYSTEMv16.s" 
