#ifndef __UTIL_H__
#define __UTIL_H__

#include <stdio.h>

typedef struct {
  char *nombre;
  int edad;
  char *lugarDeNacimiento;
} Persona;

// es_simbolo: char -> int
// Recibe un caracter,
// Devuelve verdadero si el caracter es un simbolo de la tabla ASCII, falso en
// caso contrario.
int es_simbolo(char c);

// get_line: FILE* int -> char*
// Recibe un puntero a un archivo y un flag permitirSimbolos,
// Lee una linea del archivo,
// Si permitirSimbolos es falso, excluye a todos los simbolos de la tabla ASCII.
// Si permitirSimbolos es verdadero, no excluye ningún caracter.
// Si no hay mas lineas para leer, devuelve NULL.
char *get_line(FILE *archivo, int permitirSimbolos);

// imprimir_persona: void* -> void
// Recibe un puntero a un dato (Persona*),
// Muestra en pantalla los datos de la persona con el formato:
// "nombre, edad, lugarDeNacimiento"
// Esta funcion es de tipo FVisitante.
void imprimir_persona(void *dato);

// imprimir_cadena: void* -> void
// Recibe un puntero a un dato (char*),
// Muestra en pantalla el contenido de la cadena.
// Esta funcion es de tipo FVisitante.
void imprimir_cadena(void *dato);

// escribir_persona: void* FILE* -> void
// Recibe un puntero a un dato (Persona*) y un puntero a un archivo,
// Escribe una linea en el archivo con los datos de la persona con el formato:
// "nombre, edad, lugarDeNacimiento"
// Esta funcion es de tipo FEscritora.
void escribir_persona(void *dato, FILE *archivo);

// escribir_cadena: void* FILE* -> void
// Recibe un puntero a un dato (char*) y un puntero a un archivo,
// Escribe una linea en el archivo con el contenido de la cadena.
// Esta funcion es de tipo FEscritora.
void escribir_cadena(void *dato, FILE *archivo);

// destruir_persona: void* -> void
// Recibe un puntero a un dato (Persona*),
// Destruye completamente la persona.
// Esta funcion es de tipo FDestructora.
void destruir_persona(void *dato);

// destruir_cadena: void* -> void
// Recibe un puntero a un dato (char*),
// Destruye la cadena.
// Esta funcion es de tipo FDestructora.
void destruir_cadena(void *dato);

// copiar_persona: void* -> void*
// Recibe un puntero a un dato (Persona*),
// Crea y devuelve una copia completa de la persona.
// Esta funcion es de tipo FCopiadora
void *copiar_persona(void *dato);

// copiar_cadena: void* -> void*
// Recibe un puntero a un dato (char*),
// Crea y devuelve una copia de la cadena.
// Esta funcion es de tipo FCopiadora
void *copiar_cadena(void *dato);

#endif /* __UTIL_H__ */
