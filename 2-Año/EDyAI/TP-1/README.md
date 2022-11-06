# EDyAI - TRABAJO PRACTICO 1
## Juan Cruz de La Torre y Bautista Marelli
---

### Modo de uso

```sh
$ make
$ ./parte1 [nombres.txt] [paises.txt] [personas.txt]
$ ./parte2 [personas.txt]
```

Dentro de `parte1.c` y `parte2.c` hay información más detallada del funcionamiento de cada programa respectivamente.

### Comentarios sobre la implementación

- Decidimos usar listas doblemente enlazadas circulares sobre listas simplemente enlazadas porque en muchos casos debimos usar `glist_agregar_final` (para mantener el orden de la lista al hacer `glist_map` y `glist_filter`, por ejemplo). Además, nos es útil la posibilidad de recorrer la lista en las dos direcciones al tomar un dato al azar de la lista en `glist_dato_random`.

- Para la lectura de los archivos, hicimos lo siguiente:
  - Creamos una función `get_line` que recibe un puntero a un archivo y un flag permitirSimbolos, y devuelve una línea del archivo.
  - La función lee caracteres de a uno y los va guardando en un buffer hasta llegar a un salto de línea (o EOF). Si la línea comienza con saltos de línea, los saltea hasta encontrar un caracter que no lo es. De esta manera solucionamos el hecho de que los archivos recibidos usaban `\r\n` al final de cada línea.
  - Si permitirSimbolos es verdadero, incluye en el buffer todos los caracteres que encuentra. Si es falso, solo agrega al buffer letras, espacios y caracteres que no se encuentran entre 0 y 255.
  - De esta forma, si la codificación del sistema operativo permite leer caracteres entre 0 y 255, dejará pasar correctamente los caracteres válidos. Sin embargo, si la codificación solo lee hasta 127 y considera caracteres como 'á' como 2 caracteres distintos, los valores de estos son negativos y por lo tanto están fuera del rango de la tabla ASCII (entre 0 y 255) y los dejamos pasar.
