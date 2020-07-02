# !/usr/bin/python3
# -*- coding: utf-8 -*-
from termcolor import colored
import os
import sys

# Representamos a un maze como una list(list(str)):
# maze: list(list(str))
# Por ejemplo:
# [["0", "0", "0", "0", "0", "0"],
#  ["1", "1", "1", "0", "1", "1"],
#  ["1", "1", "1", "0", "1", "1"],
#  ["1", "1", "0", "0", "1", "1"],
#  ["1", "1", "0", "1", "1", "1"],
#  ["1", "1", "0", "0", "2", "1"]]

# Llamamos a colored(maze) al maze que fue editado con la libreria termcolor

# El archivo con el laberinto tiene que tener la siguiente forma:
# - Cada linea tiene que ser una fila del laberinto
# - Representamos con "1" las paredes
# - Representamos con "0" los espacios en blanco
# - Representamos con "-" los lugares visitados
# - Representamos el objetivo con "2"
# - Cada valor (int) tienen que estar separados con un espacio
# - Importante! El archivo debe finalizar con un salto de línea
# Ejemplo:

# 0 1 0 0 0 1 0 0 0 1
# 0 1 0 1 0 1 0 1 0 1
# 0 1 0 1 0 1 0 1 0 1
# 0 1 0 1 0 1 0 1 0 1
# 0 1 0 1 0 1 0 1 0 1
# 0 1 0 1 0 1 0 1 0 1
# 0 1 0 1 0 1 0 1 0 1
# 0 1 0 1 0 1 0 1 0 1
# 0 1 0 1 0 1 0 1 0 1
# 0 0 0 1 0 0 0 1 0 2
#


# parse_maze: file -> maze
# Recibe un archivo que contiene el maze, el cual tiene que cumplir las
# caracteristicas descriptas
# Devuelve el maze que esta representado en el archivo
def parse_maze(f):
    maze = [line.strip().split(" ") for line in f.readlines()]

    return maze


# prefer_objective: maze list(tuple(int, int)) -> list(tuple(int, int))
# Recibe un maze y una lista de tupla de numeros
# Esta lista representa una lista de coordenadas las cuales son los lugares que
# podemos visitar
# Devuelve una lista de tuplas
# En el caso de que el objetivo este en unos de esos espacios que podemos
# visitar, devuelve una lista con esa coordenada
# De lo contrario devuelve la lista recibida anteriormente
def prefer_objective(maze, free_spaces):
    spaces = []

    for space in free_spaces:
        if (maze[space[0]][space[1]] == "2"):
            spaces.append(space)

    if len(spaces) == 0:
        return free_spaces

    return spaces


# possible_actions: maze tuple(int, int) -> list(tuple(int, int))
# Recibe un maze y una tupla de numeros
# Los elementos de la tuplas representan la fila y la columna dentro del
# laberinto
# Devuelve una lista de tuplas que representan las coordenadas a la cuales
# nos podemos mover
# Tenemos como prioridad devolver primero la posibilidades de mover hacia
# abajo o hacia la derecha. Luego consideramos a para arriba y la izquierda
def possible_actions(maze, position):
    free_spaces = []
    n_rows = len(maze)
    n_cols = len(maze[0])

    if (position[0] != n_rows - 1 and
        maze[position[0] + 1][position[1]] != "1" and
            maze[position[0] + 1][position[1]] != "-"):
        free_spaces.append((position[0] + 1, position[1]))

    if (position[1] != n_cols - 1 and
        maze[position[0]][position[1] + 1] != "1" and
            maze[position[0]][position[1] + 1] != "-"):
        free_spaces.append((position[0], position[1] + 1))

    if (position[0] != 0 and
        maze[position[0] - 1][position[1]] != "1" and
            maze[position[0] - 1][position[1]] != "-"):
        free_spaces.append((position[0] - 1, position[1]))

    if (position[1] != 0 and
        maze[position[0]][position[1] - 1] != "1" and
            maze[position[0]][position[1] - 1] != "-"):
        free_spaces.append((position[0], position[1] - 1))

    return prefer_objective(maze, free_spaces)


# color_maze: maze list(tuple(int, int)) -> colored(maze)
# Recibe una laberinto y una lista de tuplas
# Las tuplas representan las coordenadas que forman la solucion del laberinto
# Esta funcion cambia el color de los elementos que se encuentran en las
# coordenadas que se encuentran en la lista de tuplas
# Devuelve un colored(maze), para que sea mas facil visualizar el camino
# Representamos con "+" (verde) al camino resuelve el laberinto
# Representamos con "-" (blanco) a los espacios que visitamos y
# no llegan al objetivo
# Representamos con "1" (rojo) a las paredes
# Representamos con " " a los espacios que no visitamos
def color_maze(maze, steps=[]):
    for row in range(len(maze)):
        for col in range(len(maze[0])):
            if ((row, col) in steps):
                if (maze[row][col] == "2"):
                    maze[row][col] = colored("+", color="yellow")

                else:
                    maze[row][col] = colored("+", color="green")

            elif (maze[row][col] == "-"):
                maze[row][col] = colored(maze[row][col], color="blue")

            elif (maze[row][col] == "2"):
                maze[row][col] = colored(maze[row][col], color="yellow")

            elif (maze[row][col] == "0"):
                maze[row][col] = maze[row][col] = " "

            else:
                maze[row][col] = colored("1", color="red")

    return maze


# display_maze: maze bool list(tuple(int, int)) -> None
# Recibe un laberinto y el camino hacia la salida y lo muestra
# En el caso que visual sea True, colorea el camino
def display_maze(maze, steps=[]):
    maze = color_maze(maze, steps)

    print("")
    print("\n".join([" ".join(row) for row in maze]))


# solve_maze: maze -> list(tuple(int, int))
# Recibe un maze
# Devuelve una lista con tuplas que representan coordenadas
# Esta lista contiene las coordenadas espesificas que resuelven el laberinto
# Para poder resolver el maze y no entrar en  lugares visitados, cambia los
# "0" que visito por "-"
def solve_maze(maze):
    is_solve = False
    current_position = (0, 0)
    steps = []

    while not is_solve:
        free_spaces = possible_actions(maze, current_position)
        n_actions = len(free_spaces)

        if len(steps) == 0 and n_actions == 0:
            print(colored("No se pudo resolver el laberinto!", color="red"))
            is_solve = True

        if (n_actions == 0):
            maze[current_position[0]][current_position[1]] = "-"
            if (len(steps) != 0):
                current_position = steps.pop()

        else:
            maze[current_position[0]][current_position[1]] = "-"
            steps.append(current_position)
            current_position = free_spaces[0]

            element_in_maze = maze[current_position[0]][current_position[1]]

            if element_in_maze == "2":
                steps.append(current_position)
                print(colored("Se pudo resolver el laberinto!", color="green"))
                is_solve = True

    return steps


if __name__ == "__main__":
    done = False
    if (len(sys.argv) == 3):
        print("Trabajo Practico Final")
        print("Alumno: Bautista Marelli\n")

        filename = str(sys.argv[1])
        VISUAL = sys.argv[2] == "1"
        try:
            with open(filename, "r") as f:
                maze = parse_maze(f)

                input(colored(">>> Enter para continuar", color="green"))
                # borramos la pantalla
                os.system('cls' if os.name == 'nt' else 'clear')

                steps = solve_maze(maze)
                print(steps)

                if VISUAL:
                    display_maze(maze, steps)

        except FileNotFoundError:
            print(colored("El archivo no existe", color="red"))
    else:
        print(colored("La cantidad de argumentos es incorrecta!", color="red"))
        print(colored("MODO DE USO: python main.py [entrada.txt] [visual]",
                      color="red"))
