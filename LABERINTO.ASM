; Proyecto 2 - EIF205 - Laberinto en EMU8086
; Integrantes: Bryan Rojas Barrantes y Carlos Andres Romero
; Juego en modo texto. Controles W A S D, P y R.

.model small
.stack 100h

.data
; Cada mapa tiene 7 filas de 12 caracteres (84 bytes).
; # pared, * moneda, E salida y @ inicio.
mapa1 db '############'
      db '#@  *      #'
      db '# #### ### #'
      db '#    #     #'
      db '#### # ### #'
      db '#*     * E #'
      db '############'
mapa2 db '############'
      db '#@ #     * #'
      db '#  # ### # #'
      db '##   #   # #'
      db '#  ### #   #'
      db '#*     # E*#'
      db '############'
mapa3 db '############'
      db '#@    #   *#'
      db '### # # ####'
      db '#   #      #'
      db '# ### #### #'
      db '#*    *  E #'
      db '############'

tablero db 84 dup(' ')
posicion dw 13          ; fila 1, columna 1: (1 * 12) + 1
nivel db 1
monedas db 3
movimientos db 45
puntos dw 0
record dw 0             ; se conserva mientras el programa siga abierto
estado db 0             ; 0 jugando, 1 derrota, 2 victoria
tecla db 0
columna db 0
posicion_anterior dw 13  ; permite borrar solo la @ anterior
nivel_anterior db 1

menu1 db 13,10,'=== LABERINTO EIF205 ===',13,10,'$'
menu2 db '1. Jugar',13,10,'2. Salir',13,10,'Seleccione: $'
titulo db '=== LABERINTO ===',13,10,'$'
txtNivel db 'Nivel: $'
txtPuntos db '   Puntos: $'
txtRecord db '   Record: $'
txtMov db 13,10,'Movimientos: $'
txtMonedas db '   Monedas restantes: $'
txtAyuda db 13,10,'@ jugador  # pared  * moneda  E salida',13,10
         db 'W A S D mover | P pausa | R reiniciar | Q menu',13,10
         db 'Recoge las 3 monedas y llega a la salida.',13,10,'$'
txtPausa db 13,10,'PAUSA - presiona P para continuar.',13,10,'$'
txtPierde db 13,10,'GAME OVER: se acabaron los movimientos.',13,10,'$'
txtGana db 13,10,'GANASTE: completaste los 3 niveles.',13,10,'$'
txtBorrarLinea db '                                                            $'
txtFinal db 'R = volver a jugar, Q = menu principal',13,10,'$'

; ------------------- MACROS -------------------
; Simplifican secuencias repetitivas de salida sin cambiar la logica del juego.

; Imprime una cadena terminada en '$'.
MOSTRAR_TEXTO MACRO mensaje
    lea dx, mensaje
    call escribir
ENDM

; Imprime retorno de carro y salto de linea.
SALTO_LINEA MACRO
    mov dl, 13
    call imprimir_caracter
    mov dl, 10
    call imprimir_caracter
ENDM

.code
inicio:
    mov ax, @data
    mov ds, ax
    mov es, ax

menu:
    call limpiar_pantalla
    MOSTRAR_TEXTO menu1
    MOSTRAR_TEXTO menu2
    call leer_tecla
    cmp al, '1'
    je nueva_partida
    cmp al, '2'
    je salir
    jmp menu

nueva_partida:
    mov puntos, 0
    mov nivel, 1
    mov estado, 0
    call cargar_nivel
    call mostrar_juego

juego:
    call leer_tecla
    cmp al, 'q'
    je menu
    cmp al, 'r'
    je nueva_partida
    cmp al, 'p'
    je pausar
    mov bx, posicion
    mov posicion_anterior, bx
    mov bl, nivel
    mov nivel_anterior, bl
    call mover_jugador
    ; Si cambiamos de nivel, dibujamos el mapa nuevo completo.
    mov bl, nivel_anterior
    cmp nivel, bl
    jne dibujar_nivel_nuevo
    call actualizar_movimiento
    jmp verificar_estado

dibujar_nivel_nuevo:
    call mostrar_juego
verificar_estado:
    cmp estado, 1
    je derrota
    cmp estado, 2
    je victoria
    jmp juego

pausar:
    MOSTRAR_TEXTO txtPausa
espera_pausa:
    call leer_tecla
    cmp al, 'p'
    jne espera_pausa
    call mostrar_juego       ; borrar texto de pausa al continuar
    jmp juego

derrota:
    call mostrar_juego
    MOSTRAR_TEXTO txtPierde
    jmp opciones_final

victoria:
    call mostrar_juego
    MOSTRAR_TEXTO txtGana

opciones_final:
    MOSTRAR_TEXTO txtFinal
esperar_final:
    call leer_tecla
    cmp al, 'r'
    je nueva_partida
    cmp al, 'q'
    je menu
    jmp esperar_final

salir:
    mov ax, 4c00h
    int 21h

; ------------------- PROCEDIMIENTOS -------------------

limpiar_pantalla proc
    mov ax, 0003h           ; modo texto 80x25 y limpiar
    int 10h
    ret
limpiar_pantalla endp

escribir proc
    ; DX = direccion de texto terminado en $
    mov ah, 09h
    int 21h
    ret
escribir endp

leer_tecla proc
    ; AL = tecla en minuscula, sin mostrarla en pantalla
    mov ah, 08h
    int 21h
    cmp al, 'A'
    jb tecla_lista
    cmp al, 'Z'
    ja tecla_lista
    add al, 32
tecla_lista:
    ret
leer_tecla endp

cargar_nivel proc
    ; Copia el mapa elegido a un tablero modificable.
    push ax
    push cx
    push si
    push di
    mov si, offset mapa1
    cmp nivel, 2
    jne revisar_tercero
    mov si, offset mapa2
revisar_tercero:
    cmp nivel, 3
    jne copiar_mapa
    mov si, offset mapa3
copiar_mapa:
    mov di, offset tablero
    mov cx, 84
    cld
    rep movsb
    mov byte ptr tablero[13], ' ' ; la @ se dibuja aparte
    mov posicion, 13
    mov monedas, 3
    mov movimientos, 45
    pop di
    pop si
    pop cx
    pop ax
    ret
cargar_nivel endp

; Redibujo completo: solo al empezar, cambiar de nivel o salir de pausa.
mostrar_juego proc
    push ax
    push bx
    push cx
    push dx
    push si
    call limpiar_pantalla
    MOSTRAR_TEXTO titulo
    call mostrar_marcador
    mov si, offset tablero
    xor bx, bx
    mov cx, 84
    mov columna, 0
pintar_celda:
    mov dl, [si]
    cmp bx, posicion
    jne celda_lista
    mov dl, '@'
celda_lista:
    call imprimir_caracter
    inc si
    inc bx
    inc columna
    cmp columna, 12
    jne siguiente_celda
    mov columna, 0
    mov dl, 13
    call imprimir_caracter
    mov dl, 10
    call imprimir_caracter
siguiente_celda:
    loop pintar_celda
    MOSTRAR_TEXTO txtAyuda
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
mostrar_juego endp

; Marcador ocupa solamente las filas 1 y 2, no toca el mapa.
mostrar_marcador proc
    push ax
    push dx
    MOSTRAR_TEXTO txtNivel
    xor ax, ax
    mov al, nivel
    call imprimir_numero
    MOSTRAR_TEXTO txtPuntos
    mov ax, puntos
    call imprimir_numero
    MOSTRAR_TEXTO txtRecord
    mov ax, record
    call imprimir_numero
    MOSTRAR_TEXTO txtMov
    xor ax, ax
    mov al, movimientos
    call imprimir_numero
    MOSTRAR_TEXTO txtMonedas
    xor ax, ax
    mov al, monedas
    call imprimir_numero
    SALTO_LINEA
    pop dx
    pop ax
    ret
mostrar_marcador endp

; Posiciona el cursor en pantalla. DH=fila, DL=columna.
posicionar_cursor proc
    push ax
    push bx
    mov ah, 02h
    mov bh, 0
    int 10h
    pop bx
    pop ax
    ret
posicionar_cursor endp

; Dibuja una sola celda. BX=indice, AL=caracter.
pintar_una_celda proc
    push ax
    push bx
    push dx
    mov ah, 0
    push ax                ; guardar el caracter
    mov ax, bx
    mov dl, 12
    div dl                 ; AL=fila (0..6), AH=columna (0..11)
    mov dh, al
    add dh, 3              ; mapa empieza en fila de pantalla 3
    mov dl, ah
    call posicionar_cursor
    pop ax
    mov dl, al
    call imprimir_caracter
    pop dx
    pop bx
    pop ax
    ret
pintar_una_celda endp

; Actualiza solo 2 celdas y 2 lineas del marcador.
actualizar_movimiento proc
    push ax
    push bx
    push dx
    mov bx, posicion_anterior
    mov al, tablero[bx]
    call pintar_una_celda
    mov bx, posicion
    mov al, '@'
    call pintar_una_celda
    mov dh, 1
    mov dl, 0
    call posicionar_cursor
    MOSTRAR_TEXTO txtBorrarLinea
    mov dh, 2
    mov dl, 0
    call posicionar_cursor
    MOSTRAR_TEXTO txtBorrarLinea
    mov dh, 1
    mov dl, 0
    call posicionar_cursor
    call mostrar_marcador
    pop dx
    pop bx
    pop ax
    ret
actualizar_movimiento endp

imprimir_caracter proc
    ; DL = caracter
    mov ah, 02h
    int 21h
    ret
imprimir_caracter endp

imprimir_numero proc
    ; Imprime AX en decimal (0 a 65535).
    push ax
    push bx
    push cx
    push dx
    xor cx, cx
    mov bx, 10
convertir:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne convertir
imprimir_digito:
    pop dx
    add dl, '0'
    call imprimir_caracter
    loop imprimir_digito
    pop dx
    pop cx
    pop bx
    pop ax
    ret
imprimir_numero endp

mover_jugador proc
    ; AL = direccion. BX = posible nueva posicion.
    push ax
    push bx
    push dx
    mov bx, posicion
    cmp al, 'w'
    je subir
    cmp al, 's'
    je bajar
    cmp al, 'a'
    je izquierda
    cmp al, 'd'
    je derecha
    jmp fin_mover
subir:
    sub bx, 12
    jmp comprobar
bajar:
    add bx, 12
    jmp comprobar
izquierda:
    dec bx
    jmp comprobar
derecha:
    inc bx
comprobar:
    ; Las paredes exteriores impiden salir del tablero.
    cmp bx, 84
    jae fin_mover
    cmp byte ptr tablero[bx], '#'
    je fin_mover
    cmp byte ptr tablero[bx], 'E'
    jne avanzar
    cmp monedas, 0
    jne fin_mover         ; salida bloqueada hasta recoger todo
avanzar:
    mov posicion, bx
    dec movimientos
    cmp byte ptr tablero[bx], '*'
    jne ver_salida
    mov byte ptr tablero[bx], ' '
    dec monedas
    add puntos, 10
    call actualizar_record
ver_salida:
    cmp byte ptr tablero[bx], 'E'
    jne ver_derrota
    add puntos, 50
    call actualizar_record
    cmp nivel, 3
    je juego_ganado
    inc nivel
    call cargar_nivel
    jmp fin_mover
juego_ganado:
    mov estado, 2
    jmp fin_mover
ver_derrota:
    cmp movimientos, 0
    jne fin_mover
    mov estado, 1
fin_mover:
    pop dx
    pop bx
    pop ax
    ret
mover_jugador endp

actualizar_record proc
    push ax
    mov ax, puntos
    cmp ax, record
    jbe record_igual
    mov record, ax
record_igual:
    pop ax
    ret
actualizar_record endp

end inicio
