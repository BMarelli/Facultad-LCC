# Trabajo Práctico 1 - Sistemas Operativos I
## Juan Cruz De La Torre y Bautista Marelli

### Modo de uso

Para compilar el programa y generar un archivo ejecutable llamado `simulador` puede hacer uso del `Makefile` ejecutando:

```sh
make
```

El programa acepta como argumentos por entrada estándar el nombre de un archivo para tomar como input y otro para el output.
Esto es, si se quiere correr el programa con la semilla `File_Path/Nombre.game` y guardar el resultado en `File_Path/Nombre.final` puede ejecutar

```sh
./simulador [archivo_de_entrada] [archivo_de_salida]
```

Alternativamente, si no provee un nombre de archivo para el output, el programa guardará el resultado de la ejecución en la misma ubicación donde se encuentra la semilla y con el mismo nombre, pero con la extensión ".final".

### Implementación

En esta implementación del juego de la vida representamos la información del juego y del tablero de una manera similar a como fue propuesta por la cátedra. Decidimos modificar el código de base provisto por la cátedra, en particular las signaturas y nombres de varias funciones, para mantener consistencia con el estilo de código y nomenclatura que usamos. De todas formas, definimos de manera adicional implementaciones de los métodos según las signaturas del código provisto por si fuera necesario para correr algún test automático.

#### Tablero (board_t)

El tablero esta representado por un `char*** world`, que puede ser interpretado como una matriz tri-dimensional de tamaño 2 x nrows x ncols.
Utilizamos `current` (que toma los valores 1 o 0) para alternar entre `world[current]` y `world[!current]` como tablero actual y futuro respectivamente. Al final de cada iteración, alternamos el valor de current para cambiar el tablero actual.

Representamos las células vivas con el caracter 'O' y las muertas con 'X', pero a la hora de ser guardadas en el tablero estas se representan como 1 ó 0 (respectivamente). Hacemos este cambio para hacer más simple el cálculo de la cantidad de vecinos vivos de una celda (ver `board_get_neighbors`), y en una posible mejora de la implementación podría cambiarse la manera de guardar los datos para utilizar más eficientemente la memoria disponible (usar 1 bit por celda).

### Paralelización

La estrategia que utilizamos para dar uso a la paralelización en el programa es crear varios hilos según el resultado de la llamada a la función `get_nprocs()`, y asignar a cada hilo el cómputo de las siguientes generaciones de determinadas partes del tablero de modo equitativo. En general, si hay `n` procesadores disponibles, la asignación es:

```
XXXXXXXXXOXXXXXXXXXOOOOX <- hilo 1
OOOOOXOOOOOOOOOXOOOOOOOX <- hilo 2
OXOXXXXXXXXXXXXXXXOOOXOX <- hilo 3
...
OXOXXXXXXXXXXXXXXXOOOXOX <- hilo n
OXOXXXXXXXXXXXXXXXOOOXOX <- hilo 1
OXOXXXXXXXXXXXXXXXOOOXOX <- hilo 2
OXOXXXXXXXXXXXXXXXOOOXOX <- hilo 3
...
```

Si la cantidad de columnas es mas grande que la cantidad de filas del tablero, en vez de realizar una asignación por filas se realiza una asignación por columnas. Además, si tanto la cantidad de filas como de columnas es menor a la cantidad de procesadores disponibles, se crean solo los hilos que pueden ser utilizados (`max(nrows, ncols)`).

De este modo, cada hilo recorre su región asignada celda por celda, calcula el valor de la siguiente generación y la escribe en el tablero futuro. Cuando cada hilo termina de calcular la siguiente generación de todas las filas/columnas que le corresponden, espera con una barrera a que los hilos restantes lleguen antes de continuar.

Utilizamos una implementación de barreras de condición similar a la propuesta en los ejercicios de la práctica, con la diferencia de que al crear la barrera se puede asignar una función y un puntero a una estructura con argumentos para ejecutarla en el momento que el último hilo llega a la barrera. En nuestro caso, estos es usado para cambiar el tablero actual cambiando `game->board->current` a `!game->board->current` con la función `on_broadcast` definida en `game.c`. Si se quisiera, se podría agregar a dicha función código para imprimir el tablero luego de cada iteración si se quisiera hacer más interactivo.

Dada la implementación, vale la pena destacar que no pueden producirse deadlocks. A medida que los hilos llegan a la barrera, esperan al resto hasta que el último en llegar realiza un broadcast al resto de los hilos, de modo que todos los hilos pueden continuar su ejecución (ver `barrier.c`). Además, todos los hilos llegan a la barrera la misma cantidad de veces, por lo que siempre que un hilo llega a la barrera y espera, tarde o temprano el resto de los hilos también lo harán.

Por otra parte, como cada hilo cuenta con la información necesaria para computar la siguiente generación en cada iteración y la lectura y escritura se realizan en distintos sectores de memoria, por lo que no es posible que haya conflictos de este tipo.
