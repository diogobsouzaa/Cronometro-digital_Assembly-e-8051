;Diogo Barboza de Souza - NUSP: 12745657

org 0000h ;origem no endereço 0000h

main:
;inicializando as variaveis
mov r0, #0
mov r1, #0
mov r2, #0;
mov r3, #0
mov r4, #0;
mov r5, #3
acall botoes_inicio ;chamada da função que esepra um botão ser apertado
mov dptr, #segmentos ; move para dptr todos os numeros que serão usados na contagem
acall contagem ;chama função da contagem

botoes_inicio:
;Verificação se foi apertado um dos botões e pulando para uma label que coloca o valor que será usado no delay
jnb p2.0, zero
jnb p2.1, um
jnb p2.2, um
jnb p2.3, um
jmp botoes_inicio
ret

botoes: ;função para mudar de botão em meio a contagem
cjne r5, #1, Bum ;jmp apenas se o botão 1 não for apertado, r5 = 1 significa botão 1 apertado
cjne r5, #0, Bzero ;;jmp apenas se o botão 1 não for apertado, r5 = 0 significa botão 0 apertado

Bzero:
jnb p2.0, zero ;verifica se p2.0 foi apertado
jmp um ;jmp para recarregar novamente os valores caso seja apenas p2.1 apertado
ret
bum:
jnb p2.1, um ;verifica se p2.0 foi apertado
jmp zero ;jmp para recarregar novamente os valores caso seja apenas p2.1 apertado
ret

zero: ;coloca os valores adequados que serão usados no delay
;0,25s
mov r1, #100 ;se foi colocado 100 para a melhor visualização no display, mas para ser 0,25s como pedido deve se colocar 500
mov r2, #250
mov r5, #0
ret

um: ;coloca os valores adequados que serão usados no delay
;1s
mov r1, #1000
mov r2, #500
mov r5, #1
ret

contagem: ;função da contagem em si
mov r4, #10 ;contador para auxiliar na contagem
continue:

mov A, r3 ;r3 = 0, posicionando o inicio da contagem
movc A, @A+dptr ;usando A como um ponteiro para percorrer dptr
mov p1, A ;atriindo o valor do numero para o display p1
acall delay ;chamada de delay entre numeros
inc r3 ;aumentando o valor de r3 para ser usado na proxima contagem
DJNZ r4, continue ;diminuindo o valor de r4 e retomando a contagem
mov r4, #1 ;colocando 1 em r4 para ser usado na função "acabou"
acall acabou ;chamada da função, sinalizando que a contagem acabou
jmp main

acabou: ;função usada quando a contagem acabou
mov p1, #10111111b ;acendendo apenas o led do meio do numero do display
acall delay_final ;chamando delay do fim da contagem
djnz r4, acabou ;diminui r4 e ser for 0 continua, caso contrario começa função "acabou" novamente, sendo assim, mudando o valor de r4 pode-se fazer o delay entre uma contagem e outra maior.
acall desligar ;chamada de fuunção para desligar display
ret

segmentos: ;lista de numeros que serão usados em binario
db 11000000b ;0
db 11111001b ;1
db 10100100b ;2
db 10110000b ;3
db 10011001b ;4
db 10010010b ;5
db 10000010b ;6
db 11111000b ;7
db 10000000b ;8
db 10010000b ;9

desligar: ;desliga o led p1
mov p1, #11111111b
;setb p2.0
ret

delay_final: ;função usada para o delay quando se acabar a contagem
jnb p2.2, dois ;verifica se p2.2 esta apertado
jnb p2.3, tres ;verifica se p2.3 esta apertado
jnb p2.0, delay ;verifica se p2.0 esta apertado
jnb p2.1, delay ;verifica se p2.1 esta apertado

dois: ;delay para se p2.2 for apertado, tendo delay de 1s no final da contagem
mov r6, #1000
iniciod:
mov r7, #500
djnz r7, $
djnz r6, iniciod
ret
tres: ;delay para se p2.2 for apertado, tendo delay de 0,25s no final da contagem
mov r6, #100 ;500
iniciot:
mov r7, #250
djnz r7, $
djnz r6, iniciot
ret
 
delay: ;delay padrão usado entre cada numero e/ou no final da contagem se apertado p2.0 e p2.1
mov A, r2
inicio:
mov r2, A
DJNZ r2, $
DJNZ r1, inicio
acall botoes ;chamada de função para verificar se um botão foi apertado durante a contagem 
RET	

end
