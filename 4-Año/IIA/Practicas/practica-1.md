# Practica 1
## Ejercicio 1
### Apartado 1
Estados: 
* matriz $m \in M_{3*3}$ donde cada $m_{i,j} \in \{ 0, 1,2,3,4,5,6,7,9\}$.
   
* Cada $m_{i,j} \neq m_{l,k}$ con $i,j \neq l,k$.

* Representamos el espacio vacio con el $-1$.
  
*Estado Inicial*: Cualquier matriz $m \in \{1,2,3\}^2$ es un estado inicial.

*Estado Final*: `[[1, 2, 3],
                [8, 0, 4],
                [7, 6, 5]]`

*Movimientos*: movimientosValidos()

```
mover_ficha(f)
  pos_f = (i, j)
  ady = adyacentes(f)
  // Si la ficha es adyacente a un espacio en blanco la podemos mover   allí
  if pos_0 in ady
  temp = pos_f
  pos_f = pos_0 // intercambiamos
  pos_o = temp
adyacentes(f)
  pos_f = (i, j)
  adyacentes = []
  arriba = i-1 >= 0 ? [(i-1, j)] : []
  abajo = i+1 <= 2 ? [(i+1, j)] : []
  derecha = j+1 <= 2 ? [(i, j+1)] : []
  izquierda = j-1 >= 0 ? [(i, j-1)] : []
  return arriba ++ abajo ++ derecha ++ izquierda
```

### Apartado 2
Vamos a representar los estados de la siguiente manera:

$P = [i_1, ..., i_{64}]$ donde el ultimo elemento de la secuencia es el que esta en lo alto del poste.

*Estado Inicial*:
- $P_1 = [i_1, ..., i_{64}] | size(i_n) > size(i_m), \forall n < m$
- $P_2 = []$
- $P_3 = []$

*Estado Final*:
- $P_1 = []$
- $P_2 = []$
- $P_3 = [i_1, ..., i_{64}] | size(i_n) > size(i_m), \forall n < m$

*Estados Posibles*
- $P_1 = [i_1, ..., i_l]\ |\ size(i_n) > size(i_m), \forall n < m$
- $P_2 = [j_1, ..., j_p]\ |\ size(j_n) > size(j_m), \forall n < m$
- $P_3 = [k_1, ..., k_r]\ |\ size(k_n) > size(k_m), \forall n < m$

Donde $l + p + r = 64$

*Movimientos*:

Dadas 2 torres $P_i, P_j$ donde se cumplen las restricciones:
- $P_i = [i_1, ..., i_l]$
- $P_j = [j_1, ..., j_p]$

Si $i_l < j_p$ entonces pasamos al siguiente estado:
- $P_i = [i_1, ..., i_{l-1}]$
- $P_j = [j_1, ..., j_p, i_l]$

## Ejercicio 2
### Busqueda en ancho
```python
def BFS(tree, s):
  queue = [s]
  visited = [s]

  while queue != []:
    v = queue.first()

    for w in children(v):
      if w not in visited:
        queue = queue + [w]
        visited = visited + [w]
```
En Pseudocódigo:
```
dfs_busquedaGeneral
  LISTA-NODOS = [estado inicial]
bucle hacer
  si LISTA-NODOS está vacía return FALLA
  extraer PRIMER NODO de LISTA-NODOS
  si PRIMER NODO es meta contestar con PRIMER-NODO
  LISTA-NODOS = agregar expansion(PRIMER-NODO) al final
fin bucle
```
### Busqueda en profundidad
```python
def DFS(tree, s):
  stack = [s]
  visited = []

  while stack != []:
    v = stack.pop()

    if v not in visited:
      for w in children(v):
        stack.push(w)   
```
En Pseudocódigo:
```
fs_busquedaGeneral
  LISTA-NODOS = [estado inicial]
bucle hacer
  si LISTA-NODOS está vacía return FALLA
  extraer PRIMER NODO de LISTA-NODOS
  si PRIMER NODO es meta contestar con PRIMER-NODO
  LISTA-NODOS = agregar expansion(PRIMER-NODO) al inicio
fin bucle
```
Evolución de la lista de espera de nodos

***Con BFS***
1. [I] → estado inicial
2. [A, B], nodo actual: I
3. [B, C, D], nodo actual: A
4. [C, D, E, F], nodo actual: B
5. [D, E, F, G, H], nodo actual: C
6. [E, F, G, H], nodo actual: D
7. [F, G, H, M, J], nodo actual: E
8. [G, H, M, J], nodo actual: F
9. [H, M, J], nodo actual: G
10. [M, J], Nodo actual: H
11. FIN nodo actual: M → meta

***Con DFS***
1. [I] → estado inicial
2. [A, B], nodo actual: I
3. [C, D, B] nodo actual: A
4. [G, H, D, B] nodo actual: C
5. [H, D, B] nodo actual: G
6. [D, B] nodo actual: H
7. [B] nodo actual:D
8. [E, F] nodo actual: B
9. [M, J, F] nodo actual: E
10. FIN, nodo actual: M → meta

## Ejercicio 4
  
