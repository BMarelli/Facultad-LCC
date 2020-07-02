#!usr/bin/python3
# -*- coding: utf-8 -*-

import pytest

# No realizamos test de las funcion display_maze ya que no devuelve nada, su
# unica funcion es printear el maze en la consola

# Importamos las funciones del main
from main import prefer_objective, possible_actions, solve_maze

maze = [["0", "0", "0", "0", "0", "0"],
        ["1", "1", "1", "0", "1", "1"],
        ["1", "1", "1", "0", "1", "1"],
        ["1", "1", "0", "0", "1", "1"],
        ["1", "1", "0", "1", "1", "1"],
        ["1", "1", "0", "0", "2", "1"]]

maze2 = [["0", "0", "1", "0", "0", "0"],
         ["0", "0", "1", "0", "1", "1"],
         ["1", "1", "1", "0", "1", "1"],
         ["1", "1", "0", "0", "1", "1"],
         ["1", "1", "0", "1", "1", "1"],
         ["1", "1", "0", "0", "2", "1"]]


def test_prefer_objective():
    free_spaces = [(2, 3), (3, 2)]  # posicion: (3, 3)
    free_spaces2 = [(0, 1)]  # posicion: (0, 0)
    free_spaces3 = [(5, 4), (5, 2)]  # posicion: (5, 3)

    assert(prefer_objective(maze, free_spaces) == [(2, 3), (3, 2)])
    assert(prefer_objective(maze, free_spaces2) == [(0, 1)])
    assert(prefer_objective(maze, free_spaces3) == [(5, 4)])


def test_possible_actions():
    position = (0, 0)
    position2 = (3, 3)
    position3 = (5, 3)

    assert(possible_actions(maze, position) == [(0, 1)])
    assert(possible_actions(maze, position2) == [(2, 3), (3, 2)])
    assert(possible_actions(maze, position3) == [(5, 4)])


def test_solve_maze():
    solution = [(0, 0), (0, 1), (0, 2), (0, 3), (1, 3), (2, 3), (3, 3),
                (3, 2), (4, 2), (5, 2), (5, 3), (5, 4)]

    assert(solve_maze(maze) == solution)
    assert(solve_maze(maze2) == [])
