# Bitácora de pruebas - Proyecto 2 Laberinto EIF205

## Entorno de pruebas

Las pruebas fueron realizadas en EMU8086 utilizando la versión funcional de `LABERINTO.ASM`.

## Casos de prueba

### T01 - Inicio de partida

**Acción:** Iniciar una partida desde el menú principal.

**Resultado esperado:** Cargar el Nivel 1 con el tablero, controles, 45 movimientos y 3 monedas.

**Resultado:** Correcto.

---

### T02 - Colisión con pared

**Acción:** Intentar mover al jugador hacia una pared (`#`).

**Resultado esperado:** El jugador no debe atravesar la pared ni consumir movimientos.

**Resultado:** Correcto. La posición se mantuvo y el contador no disminuyó.

---

### T03 - Recolección de monedas

**Acción:** Recoger las tres monedas del Nivel 1.

**Resultado esperado:** Cada moneda debe sumar 10 puntos y reducir el contador de monedas.

**Resultado:** Correcto. Se obtuvieron 30 puntos y el contador llegó a 0 monedas.

---

### T04 - Salida bloqueada

**Acción:** Llegar a la salida `E` con monedas pendientes.

**Resultado esperado:** El juego no debe permitir avanzar de nivel.

**Resultado:** Correcto. La salida permaneció bloqueada mientras quedaban monedas.

---

### T05 - Cambio de nivel

**Acción:** Recoger todas las monedas y utilizar la salida.

**Resultado esperado:** Avanzar al siguiente nivel, reiniciar movimientos y monedas y agregar el bono correspondiente.

**Resultado:** Correcto. Se pasó al Nivel 2 con 80 puntos, 45 movimientos y 3 monedas.

---

### T06 - Pausa

**Acción:** Presionar `P`, intentar mover al jugador y volver a presionar `P`.

**Resultado esperado:** Durante la pausa no debe existir movimiento y al reanudar debe conservarse el estado.

**Resultado:** Correcto.

---

### T07 - Reinicio

**Acción:** Presionar `R` durante una partida.

**Resultado esperado:** Reiniciar en el Nivel 1 con puntos en 0, 45 movimientos y 3 monedas, manteniendo el récord.

**Resultado:** Correcto.

---

### T08 - Game Over

**Acción:** Agotar todos los movimientos disponibles.

**Resultado esperado:** Mostrar el estado de Game Over y permitir reiniciar con `R` o regresar al menú con `Q`.

**Resultado:** Correcto.

---

### T09 - Regreso al menú

**Acción:** Presionar `Q` durante la partida.

**Resultado esperado:** Regresar al menú principal sin cerrar EMU8086.

**Resultado:** Correcto.

---

### T10 - Victoria

**Acción:** Completar los tres niveles.

**Resultado esperado:** Mostrar el estado de victoria y actualizar el récord.

**Resultado:** Correcto. La partida finalizó con 240 puntos y récord de 240.

---

### T11 - Prueba de regresión con macros

**Acción:** Compilar la versión final que utiliza las macros `MOSTRAR_TEXTO` y `SALTO_LINEA` y repetir movimiento, recolección de moneda, pausa y reinicio.

**Resultado esperado:** Mantener el mismo comportamiento funcional después de incorporar las macros.

**Resultado:** Correcto. La moneda actualizó los puntos, la pausa bloqueó el movimiento y el reinicio restauró el Nivel 1 manteniendo el récord.

## Registro de errores

Durante las pruebas funcionales documentadas no se detectaron errores en las funciones evaluadas. Las pruebas de movimiento, colisiones, monedas, estados, puntuación, cambio de nivel y reinicio se completaron correctamente.

