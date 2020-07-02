# Aproximación a $\pi$

La idea de éste ejercicio es producir un programa que aproxime el número
$\pi$. Para esto se utilizará un método conocido como el Método de Monte-Carlo
para la aproximación de $\pi$.

La idea es imaginarnos una circunferencia de radio $r$ inscrita en un cuadrado
de lado $2*r$.

<!-- %% Circle's plot -->
<!-- \begin{tikzpicture} -->
<!--   \node (r) at (1,0) {r}; -->
<!--   \draw (-2,-2) rectangle (2,2); -->
<!--   \draw (0,0) circle [radius=2]; -->
<!--   \draw (0,0) -- (r) ; -->
<!--   \draw (r) -- (2,0) ; -->
<!-- \end{tikzpicture} -->

De esta manera el área de la circunferencia es $A_c= \pi \times r^2$ mientras que la
del cuadrado es $A_r = 4 \times r^2$ . Por lo que la razón de las áreas nos dan la
siguiente relación $\frac{A_c}{A_r} = \frac{\pi \times r^2}{4 \times r^2} =
\frac{\pi}{4}$ por lo que se concluye que $\pi = \frac{A_c \times 4}{A_r}$.

Para aproximar el valor de $\pi$ se generarán una cantidad arbitraria de puntos
`NPuntos` al azar. Asumiendo que los puntos son generados aleatoriamente, la
densidad de estos corresponderán con la razón antes establecida. Es decir, que
si contamos los puntos generados dentro de la circunferencia,
`circTotal`, podemos aproximar a $\pi$ de la siguiente forma: 
$\pi \approx \frac{4 \times \text{`circTotal`}}{\text{`NPuntos`}}$ .

Se les provee un esqueleto de código que acompaña a éste ejercicio en la carpeta
de [Ejemplos](../Ejemplos/PiCalc.c), aunque se sugiere que el estudiante de una
implementación propia.

+ Implementar de forma secuencial el algoritmo propuesto.
+ Dar una implementación paralela donde se utilicen una cantidad de hilos
`NHilos` con una *carga balanceada* entre ellos. Explique su solución.

Para observar el balance de trabajo se sugiere el uso de la herramienta *htop*.
