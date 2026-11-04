# Laberinto - Proyecto 2 EIF205

## Información general

**Autores:** Bryan Rojas Barrantes y Carlos Andrés Romero Varela  
**Curso:** Arquitectura de Computadoras (EIF205)  
**Universidad:** Universidad Nacional de Costa Rica  
**Lenguaje:** Ensamblador 8086  
**Entorno de ejecución:** EMU8086  
**Modalidad:** Juego de laberinto en modo texto

## Descripción del juego

Laberinto es un juego desarrollado en lenguaje ensamblador 8086. El objetivo es recorrer tres laberintos, recoger todas las monedas y encontrar la salida antes de agotar los movimientos disponibles.

El juego incorpora puntuación, récord durante la ejecución, colisiones con paredes, pausa, reinicio, menú principal y condiciones de victoria y derrota.

## Requisitos

- Tener instalado EMU8086 en Windows.
- Tener el archivo `LABERINTO.ASM`.

## Cómo compilar y ejecutar

1. Abrir EMU8086.
2. Seleccionar **File > Open** y abrir `LABERINTO.ASM`.
3. Presionar **Compile**.
4. Si no aparecen errores, seleccionar **Emulate**.
5. En el menú principal, pulsar `1` para jugar o `2` para salir.
6. Utilizar `W`, `A`, `S` y `D` para mover al jugador.

## Controles

| Tecla | Acción |
|---|---|
| `W` | Arriba |
| `A` | Izquierda |
| `S` | Abajo |
| `D` | Derecha |
| `P` | Pausar o reanudar |
| `R` | Reiniciar partida |
| `Q` | Volver al menú principal |

Se admiten letras mayúsculas y minúsculas.

## Símbolos

- `@`: jugador.
- `#`: pared.
- `*`: moneda.
- `E`: salida.

## Reglas

- El juego contiene tres niveles.
- Cada nivel comienza con 45 movimientos disponibles y tres monedas.
- Cada moneda suma 10 puntos.
- Para usar la salida `E` es necesario recoger todas las monedas del nivel.
- Completar un nivel suma 50 puntos adicionales.
- Un movimiento válido consume una unidad. Los intentos de atravesar una pared no consumen movimientos.
- Si los movimientos llegan a cero antes de completar el objetivo, aparece Game Over.
- Al completar el tercer nivel aparece un mensaje de victoria.
- El récord se mantiene al reiniciar la partida dentro de la misma ejecución, pero no se guarda de forma permanente al cerrar el programa.

## Características implementadas

1. Monedas que suman puntos.
2. Límite de movimientos por nivel.
3. Tres mapas para avanzar de manera progresiva.
4. Pausa, reinicio, récord, menú y pantallas de victoria y derrota.

## Organización del programa

- `cargar_nivel`: carga el mapa y prepara el nivel.
- `mostrar_juego`: muestra el tablero y los controles.
- `mostrar_marcador`: muestra nivel, puntos, récord, movimientos y monedas.
- `leer_tecla`: lee el teclado.
- `mover_jugador`: procesa movimiento, colisiones, monedas y salida.
- `actualizar_record`: actualiza la puntuación máxima.
- `imprimir_numero`: presenta números decimales.
- `posicionar_cursor`: coloca el cursor.
- `pintar_una_celda`: dibuja una casilla.
- `actualizar_movimiento`: actualiza el jugador y el marcador.
- `limpiar_pantalla`, `escribir` e `imprimir_caracter`: operaciones de texto.

### Macros

- `MOSTRAR_TEXTO`: facilita la impresión de cadenas.
- `SALTO_LINEA`: imprime un salto de línea.

## Organización de memoria

Los mapas tienen 84 caracteres, distribuidos en 7 filas por 12 columnas. El arreglo `tablero` contiene una copia del mapa activo. El programa mantiene variables para la posición del jugador, nivel, movimientos, monedas, puntos, récord y estado. Utiliza una pila declarada como `.stack 100h` (256 bytes).

## Pruebas realizadas

La versión del juego fue compilada y ejecutada en EMU8086. Se comprobaron el inicio, movimiento, colisiones, monedas, salida bloqueada, transición de nivel, puntuación, récord, pausa, reinicio, menú, Game Over y victoria.

En una prueba completa se obtuvo victoria al terminar los tres niveles con 240 puntos. Después de incorporar las macros, se recompiló el programa y se comprobaron nuevamente movimiento, moneda, pausa y reinicio.

## Control de versiones

El proyecto utiliza Git y GitHub. El historial contiene contribuciones de los dos integrantes.

**Repositorio:** https://github.com/bryanrojas77/Proyecto2_Laberinto_EIF205

## Documentación del proyecto

- [Informe técnico](docs/Informe_Tecnico_Proyecto2.pdf): arquitectura, memoria, módulos y evidencias.
- [Bitácora de pruebas](docs/Bitacora_Pruebas.md): casos de prueba y resultados observados.

## Estructura del repositorio

```text
Proyecto2_Laberinto_EIF205/
├── LABERINTO.ASM
├── README.md
└── docs/
    ├── Informe_Tecnico_Proyecto2.pdf
    └── Bitacora_Pruebas.md
```

## Estado del proyecto

El juego se encuentra implementado y fue probado en EMU8086. Las funciones principales respondieron correctamente en las pruebas registradas.
