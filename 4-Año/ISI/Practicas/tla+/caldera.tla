---- MODULE DK_SENSOR ----
EXTENDS Naturals
VARIABLES sensor

TypeInv == sensor \in Nat
--------------------------
Init == sensor=0
Senso == /\ sensor \in Nat
         /\ CHOOSE n \in Nat : sensor' = n
Next == Senso
Spec == Init /\ [][Next]_<<sensor>>
--------------------------
THEOREM Spec => []TypeInv
==========================

---- MODULE DK_CALDERA ----
EXTENDS Naturals
CONSTANT Max
ASSUME Max \in Nat
VARIABLE caldera

TypeInv == caldera \in Nat
---------------------------
Init == caldera=0
Subir == /\ caldera < Max
         /\ caldera' = caldera+1
Bajar == /\ caldera > 0
         /\ caldera' = caldera-1
Next == Bajar \/ Subir
Spec == Init /\ [][Next]_<<caldera>>
---------------------------
THEOREM Spec => []TypeInv
===========================

---- MODULE DK_TANQUE ----
EXTENDS Naturals
CONSTANTS Max
ASSUME Max \in Nat
VARIABLE tanque

TypeInv == tanque \in Nat
--------------------------
Init == tanque=0
Cargar == /\ tanque < Max
          /\ tanque' = tanque+1
Vaciar == /\ 0 < tanque
          /\ tanque' = tanque-1
Next == Vaciar \/ Cargar
Spec == Init /\ [][Next]_<<tanque>>
--------------------------
THEOREM Spec => []TypeInv
==========================


---- MODULE SISTEMA ----
EXTENDS Naturals
CONSTANTS T, P
ASSUME T, P \in Nat
VARIABLES s1, s2, caldera, tanque, accion

Temp == INSTANCE DK_SENSOR WITH sensor <- s1
Pres == INSTANCE DK_SENSOR WITH sensor <- s2
Caldera == INSTANCE DK_CALDERA
Tanque == INSTANCE DK_TANQUE

TypeInv == /\ Temp!TypeInv
           /\ Pres!TypeInv
           /\ Caldera!TypeInv
           /\ Tanque!TypeInv
           /\ accion \in {"Liberar", "none"}
------------------------
Init == accion="none"

ManejarTemp == /\ accion="none"
               /\ Temp!Senso
               /\ IF Temp!sensor < T
                  THEN Caldera!Subir
                  ELSE Caldera!Bajar
               /\ UNCHANGED <<s2, tanque, accion>>
ManejarPres == /\ accion="none"
               /\ Pres!Senso
               /\ IF Pres!sensor < P
                  THEN Tanque!Vaciar
                  ELSE Caldera!Cargar
               /\ UNCHANGED <<s1, caldera, accion>>
ActivarValvulas == /\ Temp!Senso
                   /\ Pres!Senso
                   /\ Temp!sensor=T
                   /\ Pres!sensor=P
                   /\ accion="none"
                   /\ accion'="Liberar"
                   /\ UNCHANGED <<caldera, tanque>>
Next == ManejarPres \/ ManejarTemp \/ ActivarValvulas
------------------------
THEOREM Spec => []TypeInv
========================

