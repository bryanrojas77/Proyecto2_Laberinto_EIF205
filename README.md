Laberinto - Proyecto 2 EIF205

Autores: Bryan Rojas Barrantes y Carlos Andres Romero

Curso: Arquitectura de Computadoras (EIF205)

Entorno objetivo: EMU8086, procesador Intel 8086, modo texto.

Cómo abrir y ejecutar

1\. Abrir EMU8086.

2\. Ir a File > Open y seleccionar LABERINTO.ASM.

3\. Presionar Compile y luego Emulate (según la versión, también puede usarse Run).

4\. En la ventana del programa, ingresar 1 para jugar o 2 para salir.

5\. Controlar el personaje con W A S D. Se admiten mayúsculas o minúsculas.

Objetivo y reglas

•	@ es el jugador; # son paredes; \* son monedas; E es la salida.

•	Recoger las 3 monedas y llegar a E para completar el nivel.

•	Hay 3 niveles predefinidos. Cada nivel comienza con 45 movimientos.

•	Un movimiento válido resta 1. Chocar contra una pared NO consume movimientos.

•	Cada moneda suma 10 puntos. Terminar un nivel suma 50 puntos.

•	Si los movimientos llegan a 0 antes de alcanzar la salida, aparece Game Over.

•	P: pausar / reanudar. R: comenzar una partida nueva. Q: volver al menú.

•	El récord se mantiene mientras el programa sigue abierto; se pierde al cerrar EMU8086. No se guarda en archivo.

Tres cambios respecto al laberinto básico

1\. Monedas que suman puntos.

2\. Límite de movimientos que provoca derrota.

3\. Tres laberintos de dificultad progresiva.

Estructura del programa

•	cargar\_nivel: copia el mapa seleccionado a memoria y reinicia el jugador, las monedas y los movimientos.

•	mostrar\_juego: imprime estado, contador y tablero de 7 x 12.

•	leer\_tecla: recibe el teclado sin mostrar los caracteres.

•	mover\_jugador: calcula la nueva posición y revisa paredes, monedas, salida y Game Over.

•	actualizar\_record: actualiza el récord si se supera.

•	imprimir\_numero: convierte un número a dígitos decimales para mostrarlo.

•	limpiar\_pantalla, escribir, imprimir\_caracter: utilidades de pantalla.

Explicación de memoria

Cada mapa tiene 84 bytes (7 filas × 12 columnas). El índice de un personaje se calcula como fila × 12 + columna. La posición inicial es 13 (fila 1, columna 1). tablero es una copia del mapa: al recoger una moneda, su posición cambia de \* a espacio. puntos y record ocupan 2 bytes; las demás variables de contadores son bytes, excepto posicion, que ocupa 2.

Validación pendiente

Este proyecto se ha preparado como código fuente, pero debe compilarse y ejecutarse en una instalación real de EMU8086 antes de entregarse. Se comprobaron las dimensiones y conectividad de los mapas por análisis estático, no la ejecución en el emulador.

Git (obligatorio)

Crear un repositorio e ir haciendo commits reales de ambos integrantes, por ejemplo al añadir mapas, movimiento, puntuación, pruebas y documentación. No inventar un historial de trabajo.



