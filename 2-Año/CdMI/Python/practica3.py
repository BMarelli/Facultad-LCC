#! /usr/bin/python
# -*- coding: utf-8 -*-

# 3ra Practica Laboratorio 
# Complementos Matematicos I
 
'''
Recordatorio: 
- Un camino/ciclo es Euleriano si contiene exactamente 1 vez
a cada arista del grafo
- Un camino/ciclo es Hamiltoniano si contiene exactamente 1 vez
a cada vértice del grafo
'''

def esCaminoEuleriano(grafo, camino):
    """Comprueba si una lista de aristas constituye un camino euleriano
    en un grafo.

    Argumentos:
        grafo: Grafo en formato de listas. 
               Ej: (['a', 'b', 'c'], [('a', 'b'), ('b', 'c')])

        camino: Lista de aristas. Posible camino.
                Ej: [('a', 'b'), ('b', 'c')]

    Retorno:
        boolean: camino es camino euleriano en grafo

    """
    listaAristas = grafo[1]
    esCamino = False
    if (len(camino) == len(list(set(camino))) and len(camino) == len(listaAristas)):
        esCamino = True
        for i in range(1, len(camino)):
            if camino[i][0] != camino[i - 1][1]: esCamino = False
    
    return esCamino


def esCicloEuleriano(grafo, ciclo):
    """Comprueba si una lista de aristas constituye un ciclo euleriano
    en un grafo.

    Argumentos:
        grafo: Grafo en formato de listas. 
               Ej: (['a', 'b', 'c'], [('a', 'b'), ('b', 'c')])

        camino: Lista de aristas. Posible ciclo.
                Ej: [('a', 'b), ('b', 'c')]

    Retorno:
        boolean: ciclo es ciclo euleriano en grafo
    """
    n = len(ciclo)
    return (esCaminoEuleriano(grafo, ciclo) and ciclo[0][0] == ciclo[n - 1][1])
    
def esCaminoHamiltoniano(grafo, camino):
    """Comprueba si una lista de aristas constituye un camino hamiltoniano
    en un grafo.

    Argumentos:
        grafo: Grafo en formato de listas. 
               Ej: (['a', 'b', 'c'], [('a', 'b'), ('b', 'c')])

        camino: Lista de aristas. Posible camino.
                Ej: [('a', 'b), ('b', 'c')]

    Retorno:
        boolean: camino es camino hamiltoniano en grafo

    """
    esCamino = True
    if (len(camino) == len(list(set(camino)))):
        visitados = []
        for i in range(1, len(camino)):
            if camino[i][0] == camino[i - 1][1]:
                visitados.append(camino[i][0])
            else: esCamino = False
        esCamino = (len(visitados) == len(list(set(visitados))) and esCamino)
    return esCamino

def esCicloHamiltoniano(grafo, ciclo):
    """Comprueba si una lista de aristas constituye un ciclo hamiltoniano
    en un grafo.

    Argumentos:
        grafo: Grafo en formato de listas. 
               Ej: (['a', 'b', 'c'], [('a', 'b'), ('b', 'c')])

        camino: Lista de aristas. Posible ciclo.
                Ej: [('a', 'b), ('b', 'c')]

    Retorno:
        boolean: ciclo es ciclo hamiltoniano en grafo

    """
    pass

def tieneCaminoEuleriano(grafo):
    """Comprueba si un grafo no dirigido tiene un camino euleriano.

    Argumentos:
        grafo: Grafo en formato de listas. 
               Ej: (['a', 'b', 'c'], [('a', 'b'), ('b', 'c')])

    Retorno:
        boolean: grafo tiene un camino euleriano

    """
    pass


def cicloEuleriano(grafo):
    """Obtiene un ciclo euleriano en un grafo no dirigido, si es posible

    Argumentos:
        grafo: Grafo en formato de listas. 
                Ej: (['a', 'b', 'c'], [('a', 'b'), ('b', 'c')])

    Retorno:
        lista de aristas: ciclo euleriano, si existe
        None: si no existe un camino euleriano
    """

    # Sugerencia: Usar el Algoritmo de Fleury
    # Recursos:
    # http://caminoseuler.blogspot.com.ar/p/algoritmo-leury.html
    # http://www.geeksforgeeks.org/fleurys-algorithm-for-printing-eulerian-path/
    pass

if __name__ == '__main__':
    graph_6 = (['a', 'b', 'c', 'd', 'e'],
               [('a', 'b'), ('a', 'c'), ('a', 'd'), ('a', 'e'),
                ('b', 'c'), ('b', 'd'), ('b', 'e'),
                ('c', 'd'), ('c', 'e'),
                ('d', 'e')])

    ciclo = [('a', 'b'), ('b', 'c'), ('c', 'd'), ('d', 'e'), ('e', 'c'), ('c', 'a'), ('a', 'd'),
            ('d', 'b'), ('b', 'e'), ('e', 'a')]
    print(esCicloEuleriano(graph_6, ciclo))