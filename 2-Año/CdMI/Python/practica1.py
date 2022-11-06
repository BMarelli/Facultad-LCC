# Funciones para trabajar con grafos
# - Grafos Listas
# - Grafos (Matriz Incidencia)
# - Grafos (Matriz A dyacencia)
import sys

def leer_grafo_archivo(nomberArchivo):
    listaVertices = []
    listaAristas = []
    archivo = open(nomberArchivo, "r")
    cantidadVerctores = int(archivo.readline())
    i = 0
    linea = archivo.readline()
    while (linea != ""):
        if (i < cantidadVerctores):
            listaVertices += [linea[0:len(linea) - 1]]
            i += 1 
        else:
            listaAristas += [(linea[0], linea[2])]
        linea = archivo.readline()
    
    archivo.close()
    return listaVertices, listaAristas

def imprime_grafo_lista(grafo):
    '''
    Muestra por pantalla un grafo. El argumento esta en formato de lista.
    '''
    print("Grafo Lista:")
    print((grafo[0], grafo[1]))
    print('\n')
    


def lista_a_incidencia(grafo_lista):
    '''
    Transforma un grafo representado por listas a su representacion 
    en matriz de incidencia.
    '''
    listaVertices, listaAristas = grafo_lista
    n = len(listaVertices)
    m = len(listaAristas)
    matrizIncidencia = [[0 for j in range(m)] for i in range(n)]
    for e in listaAristas:
        i, j = e
        matrizIncidencia[listaVertices.index(i)][listaAristas.index(e)] = 1
        matrizIncidencia[listaVertices.index(j)][listaAristas.index(e)] = 1
    return matrizIncidencia


def incidencia_a_lista(matriz_incidencia):
    '''
    Transforma un grafo representado una matriz de incidencia a su 
    representacion por listas.
    '''
    n = len(matriz_incidencia)
    listaAristas = []
    for i in range(n):
        for j in range(n):
            if (matriz_incidencia[i][j] == 1):
                listaAristas += [(i, j)]
    return list(range(n)), listaAristas

def imprime_grafo_incidencia(matriz_incidencia):
    '''
    Muestra por pantalla un grafo. 
    El argumento esta en formato de matriz de incidencia.
    '''
    print("Matriz de Incidencia:\n")
    print('\n'.join([''.join(['{:4}'.format(item) for item in row])  for row in matriz_incidencia]))
    print('\n')


def lista_a_adyacencia(grafo_lista):
    '''
    Transforma un grafo representado por listas a su representacion 
    en matriz de adyacencia.
    '''
    listaVertices, listaAristas = grafo_lista
    n = len(listaVertices)
    matrizIncidencia = [[0 for j in range(n)] for i in range(n)]
    for i, j in listaAristas:
        matrizIncidencia[listaVertices.index(i)][listaVertices.index(j)] = 1
        matrizIncidencia[listaVertices.index(j)][listaVertices.index(i)] = 1
    return matrizIncidencia
    


def adyacencia_a_lista(matriz_adyacencia):
    '''
    Transforma un grafo representado una matriz de adyacencia a su 
    representacion por listas.
    '''
    listaAristas = []
    n = len(matriz_adyacencia)
    for i in range(n):
        for j in range(n):
            if (matriz_adyacencia[i][j] == 1 and i <= j):
                listaAristas += [(i, j)]
    return list(range(n)), listaAristas


def imprime_grafo_adyacencia(matriz_adyacencia):
    '''
    Muestra por pantalla un grafo. 
    El argumento esta en formato de matriz de adyacencia.
    '''
    print("Matriz de Adyacencia:\n")
    print('\n'.join([''.join(['{:4}'.format(item) for item in row])  for row in matriz_adyacencia]))
    print('\n')



if __name__ == '__main__':
    if (len(sys.argv) == 2):
        grafo = leer_grafo_archivo(sys.argv[1])
        imprime_grafo_lista(grafo)
    else:
        print("La cantidad de argumentos es incorrecta!")
        print("MODO DE USO: python practica1.py [entrada.txt]")