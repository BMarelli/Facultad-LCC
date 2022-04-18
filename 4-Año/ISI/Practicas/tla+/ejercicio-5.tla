\* Designaciones:
\* - Tiempo T1 = T1
\* - Tiempo T2 = T2
\* - Tiempo T3 = T3
\* - Apretar boton = click
\* - El semaforo esta en rojo = rojo
\* - El semaforo esta en amarillo = amarillo
\* - El semaforo esta en verde = verde

--------------------- MODULE DK_BOTON ---------------------
extends Naturals
parameters
  CONSTANTS
  ASSUME
  VARIABLES boton

  TypeInv == boton \in {0, 1}
  vars == < boton >

-----------------------------------------------------------

Init == TypeInv

Click == boton /= boton'

Next == Click

Spec == Init /\ [][Next]_vars

-----------------------------------------------------------

THEOREM Spec => []TypeInv

===========================================================

------------------- MODULE DK_SEMAFORO --------------------
extends Naturals
  parameters
  CONSTANTS
  ASSUME
  VARIABLES semaforo

  TypeInv == semaforo \in {"VERDE", "AMARILLO", "ROJO"}
  vars == < semaforo >

-----------------------------------------------------------

Init == TypeInv

PonerRojo == /\ semaforo = "AMARILLO"
             /\ semaforo' = "ROJO"

PonerAmarillo == /\ semaforo = "VERDE"
                 /\ semaforo' = "AMARILLO"

PonerVerde == /\ semaforo = "ROJO"
              /\ semaforo' = "VERDE"

Next == PonerRojo \/ PonerAmarillo \/ PonerVerde

Spec == Init /\ [][Next]_vars

-----------------------------------------------------------

THEOREM Spec => []TypeInv

===========================================================

--------------------- MODULE SISTEMA ----------------------
extends Naturals
parameters
  CONSTANTS T1, T2, T3, T4
  ASSUME T1+T2+T3 <= T4
  VARIABLES boton, semaforo, accion, timers

  \A i \in {1,2} : BOTON(i) == INSTANCE DK_BOTON
  SEMAFORO == INSTANCE DK_SEMAFORO
  TIMERS == INSTANCE TIMERS

  TypeInv == /\ \A i \in {1, 2} : BOTON(i)!TypeInv
             /\ SEMAFORO!TypeInv
             /\ TIMERS!TypeInv
             /\ accion \in {0, 1, 2, 3, 4}
  vars == < boton, semaforo, accion, timer >

-----------------------------------------------------------

Init == /\ TypeInv
        /\ accion = 0
        /\ \A (i, lim) \in {(1,T1), (2,T2), (3,T3), (4,T4)} : TIMERS!Set(i, lim)

Pulsar == /\ accion = 0
          /\ \E i in {1, 2} : BOTON(i)!Click
          /\ accion' = 1
          /\ TIMERS!Start(1)
          /\ TIMERS!Start(4)
          /\ UNCHANGED < semaforo >

PonerSemAmarillo == /\ accion = 1
                    /\ TIMERS!TimeOut(1)
                    /\ SEMAFORO!PonerAmarillo
                    /\ accion' = 2
                    /\ TIMERS!Start(2)
                    /\ UNCHANGED < boton >

PonerSemRojo == /\ accion = 2
                /\ TIMERS!TimeOut(2)
                /\ SEMAFORO!PonerRojo
                /\ accion' = 3
                /\ TIMERS!Start(3)
                /\ UNCHANGED < boton >

PonerSemVerde == /\ accion = 3
                 /\ TIMERS!TimeOut(3)
                 /\ SEMAFORO!PonerVerde
                 /\ accion' = 4
                 /\ UNCHANGE < boton >

Valid == /\ accion = 4
         /\ TIMERS!TimeOut(4)
         /\ accion' = 0
         /\ UNCHANGE < boton, semaforo >

Next == \/ Pulsar 
        \/ PonerAmarillo
        \/ PonerRojo
        \/ PonerSemVerde
        \/ Valid

Spec == Init /\ [][Next]_vars

-----------------------------------------------------------

THEOREM Spec => []TypeInv

===========================================================
