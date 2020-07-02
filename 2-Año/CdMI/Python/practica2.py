#! /usr/bin/python

# 2da Practica Laboratorio 
# Complementos Matematicos I

# Un disjointSet lo representaremos como un diccionario. 
# Ejemplo: {'A':1, 'B':2, 'C':1} (Nodos A y C pertenecen al conjunto 
# identificado con 1, B al identificado on 2)

grafo_lista =  (['A','B','C','D','E','F','G'],[('A','B'),('B','C'),('A','B'),('C','D'),('E','F')])

def make_set(lista):
    '''
    Inicializa una lista de vértices de modo que cada uno de sus elementos pasen a ser conjuntos unitarios. 
    Retorna un disjointSet.
    '''
    disJointSet = {}
    listaVertices = lista[0]
    for i in range(len(listaVertices)):
        disJointSet[listaVertices[i]] = i

    # i = 1
    # for arista in listaArista:
    #     x, y = arista
    #     if (not x in disJointSet and not y in disJointSet):
    #         disJointSet[x] = i
    #         disJointSet[y] = i
    #         i += 1
    #     elif (x in disJointSet):
    #         disJointSet[y] = disJointSet[x]
    #     else:
    #         disJointSet[x] = disJointSet[y]
            
    return disJointSet




def find(elem, disjoint_set):
    '''
    Obtiene el identificador del conjunto de vértices al que pertenece el elemento.
    '''
    return disjoint_set[elem]


def union(id_1, id_2, disjoint_set):
    '''
    Dado dos identificadores de conjuntos de vértices, une dichos conjuntos.
    Retorna la estructura actualizada
    '''
    


def componentes_conexas(grafo_lista):
    '''
    Dado un grafo en representacion de lista, obtiene sus componentes conexas.
    Ejemplo:
        Entrada: [['a','b','c','d'], [('a', 'b')]]  
        Salida: [['a, 'b'], ['c'], ['d']]
    '''
    pass

if __name__ == '__main__':
    disJointSet = make_set(grafo_lista)
    print(disJointSet)
    print(find('C', disJointSet))