#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

// MODO DE USO:
// El usuario tiene que introducir el nombre del archivo, de preferencia (laberinto.txt)
// Se generara un archivo llamado maze.txt, en el cual se encuentra el laberinto

// El archivo a recibir (laberinto.txt) debe cumplir con ciertas características:
// - En la primera linea tiene que estar el tamaño que tendra el laberinto.
//   Primero es la cantidad de filas y luego la cantidad de columnas, separados por un espacio.
// - Luego, la segunda linea tiene que tener las coordenadas del objetivo, separados por un espacio.
// - Por ultimo, las lineas restantes representan las coordenadas de los muros
//   Cada elemento tiene que estar separado por espacios
// - Importante! El archivo debe tener como maximo 22 lines:
//   1 (tamaño) + 1 (objetivo) + 20 (muros)
// - Importante! El archivo debe terminar con un salto de linea
// Ejemplo: (archivo: laberinto.txt)
/*
    6 6
    5 4
    1 2
    1 4
    1 5
    2 0
    2 1
    2 2
    2 4
    2 5
    3 0
    3 1
    3 4
    3 5
    4 0
    4 1
    4 3
    4 4
    4 5
    5 0
    5 1
    5 5

*/

// Salida: (archivo: maze.txt)
/*
    0 0 0 0 0 0
    0 1 0 0 1 1
    1 1 1 0 1 1
    1 1 0 0 1 1
    1 1 0 1 1 1
    1 1 0 0 2 1

*/


// parseFile: char[] int[2][22] -> int
// Esta funcion recibe el nombre del archivo introducido por el usuario y una matriz de 2 filas y 22 columnas
// Esta matriz contiene las coordenadas que se encuentran en el archivo recibido.
// Aclaracion: El tamaño de esta matriz es de 22 ya que sabemos que el maximo de muros que podemos recibir es 20, luego
// contamos tambien el tamaño del laberinto y las coordenadas del objetivo.
// 22 = 1 (tamaño) + 1 (objetivo) + 20 (muros)
// Por ultimo, la matriz coordinates tiene 2 filas porque cada fila representa cada elemento de las coordenadas
// En el caso de que el archivo no exista, devuelve un error
// En el caso contrario, devuelve la cantidad de lineas leidas
int parseFile(char filename[], int coordinates[2][22]){
    FILE * file;
    file = fopen(filename, "r");

    if(file == NULL) {
        printf("Error: El archivo %s no existe!\n", filename);

        return -1;
    }

    int row, col;
    int i = 0;

    while(fscanf(file, "%d %d\n", &row, &col) != EOF && i < 22) {
        coordinates[0][i] = row;
        coordinates[1][i] = col;
        i++;
    }

    fclose(file);

    return i;
}


// isMazeValid: int[2][22] int -> int
// Recibe una matriz con las coordenadas obtenidas del archivo y la cantidad de coordenadas leidas
// Devuelve 1 si las coordenadas son validas y 0 de lo contrario
int isMazeValid(int coordinates[2][22], int numCordinates) {
    int numRow = coordinates[0][0];
    int numCol = coordinates[1][0];
    int rowObjective = coordinates[0][1];
    int colObjective = coordinates[1][1];
    int wrongWalls = 0;
    int index = 2;

    if(numRow <= 0 || numCol <= 0) return 0;

    if(rowObjective < 0 || colObjective < 0 || rowObjective >= numRow || colObjective >= numCol) return 0;

    while (index < numCordinates) {
        if(coordinates[0][index] < 0 || coordinates[0][index] >= numRow ||
           coordinates[1][index] < 0 || coordinates[1][index] >= numRow) {
            wrongWalls++;
        }

        index++;
    }

    if(wrongWalls) return 0;

    return 1;

}


// buildMaze: int[15][15] int[2][22] int -> void
// Esta funcion recibe una matriz que representa el laberinto, una matriz de coordenadas y la cantidad de coordenadas
// Segun las coordenadas recibidas, las cuales son del muro y del objetivo, modifica el laberinto
void buildMaze(int maze[15][15], int coordinates[2][22], int numCordinates) {
    int numRow = coordinates[0][0];
    int numCol = coordinates[0][1];
    int a = 1;

    maze[coordinates[0][1]][coordinates[1][1]] = 2; // introducimos el objetivo en su coordenada

    for (int i = 2; i < numCordinates; i++) {
        maze[coordinates[0][i]][coordinates[1][i]] = 1; // introducimos los muros en sus coordenadas
    }
}


// writeMaze: char[] int[15][15] int[2][22] -> void
// Recibe el nombre del archivo de salida, la matriz del laberinto y las coordenadas obtenidas del archivo leido
// Crea un nuevo archivo llamado segun el valor de outFilename. En el caso de que ya existe, lo reescribe sobre este
// Escribre, separado por espacios cada valor que tenga la matriz del laberinto
void writeMaze(char outFilename[], int maze[15][15], int coordinates[2][22]) {
    FILE * file;
    file = fopen(outFilename, "w+");  // creamos o sobreescribimos en el archivo maze.txt

    int numRow = coordinates[0][0];
    int numCol = coordinates[1][0];

    for (int i = 0; i < numRow; i++) {
        for (int j = 0; j < numCol; j++) {
            fprintf(file, "%d", maze[i][j]);
            
            if (j != numCol - 1) fprintf(file, " ");
        }

        fprintf(file, "\n");
    }

    printf("Se a creado el archivo: %s con el laberinto!\n", outFilename);
    
    fclose(file);
}


// runAssert: void
// Corre los asserts
void runAssert() {
    int coordinates[2][22] = {{4, 3, 1, 2}, {4, 3, 1, 2}};
    int coordinates2[2][22] = {{4, 5, 1, 2}, {4, 3, 1, 2}};
    int numCordinates = 4;

    assert(isMazeValid(coordinates, 4) == 1);
    assert(isMazeValid(coordinates2, 4) == 0);

}

int main(int argc, char *argv[]) {
    if (argc <= 3) {
        runAssert();  // corremos los asserts

        // char outFilename[] = (argc == 3) ? argv[2] : "maze.txt";
        int coordinates[2][22];  // las columnas representan coordenadas
        int maze[15][15] = {0};  // lo iniciamos con 0 ya que luego lo modificaremos segun el archivo


        int numCordinates = parseFile(argv[1], coordinates);

        if (numCordinates == -1) return -1;

        if (!isMazeValid(coordinates, numCordinates)){
            printf("Se produjo un error leyendo el archivo: %s\n", argv[1]);
            printf("Primero revise la documentacion sobre como ingresar el archivo\n");
            return -1;
        }

        buildMaze(maze, coordinates, numCordinates);
        writeMaze(argv[2], maze, coordinates);
        // writeMaze(outFilename, maze, coordinates);

        return 0;
    } 
    else {
        printf("La cantidad de argumentos es incorrecta!\n");
        printf("MODO DE USO: ./main [entrada.txt] {salida.txt}\n");
        return -1;
    }
}
