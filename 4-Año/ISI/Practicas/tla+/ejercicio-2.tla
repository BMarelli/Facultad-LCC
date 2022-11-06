---------------------- MODULE DK_SENSOR ----------------------
extends Naturals
parameters
  CONSTANTS SENSORES
  VARIABLES sensor

  TypeInv == sensor \in [SENSORES -> {0, 1}]

  vars == < sensor >
 
--------------------------------------------------------------

Init == sensor = [i \in SENSORES |-> 0]

Senso(i) == /\ sensor[i] = 0 /\ sensor[i]' = 1

Dejar(i) == sensor[i] = 1 /\ sensor[i]' = 0

Sensar(i) == Senso(i) \/ Dejar(i)

Next == \E i \in SENSORES : Sensar(i)

Spec == Init /\ [][Next]_vars

--------------------------------------------------------------

THEOREM Spec => []TypeInv

==============================================================

---------------------- MODULE DK_PUERTA ----------------------
extends Naturals
parameters
  CONSTANTS
  ASSUME
  VARIABLES puerta

  TypeInv == puerta \in {"OPEN", "CLOSE"}

  vars == < puerta >

--------------------------------------------------------------

Init == TypeInv /\ puerta = "CLOSE"

Abrir == puerta = "CLOSE" => puerta' = "OPEN"

Cerrar == puerta = "OPEN" => puerta' = "CLOSE"

Next == Abrir \/ Cerrar

Spec == Init /\ [][Next]_vars

--------------------------------------------------------------

THEOREM Spec => []TypeInv

==============================================================

----------------------- MODULE SISTEMA -----------------------
extends Naturals
parameters
  CONSTANTS
  ASSUME
  VARIABLES sensor, puerta, accion

  SENSORES == INSTANCE DK_SENSOR
  PUERTA == INSTANCE DK_PUERTA

  TypeInv == /\ SENSORES!TypeInv
             /\ PUERTA!TypeInv
             /\ puerta \in {"OPEN", "CLOSE"}
             /\ sensor \in {'TRUE', 'FALSE'}
             /\ accion \in {0, 1}
  vars == < sensor, puerta, accion >

--------------------------------------------------------------

Init == TypeInv /\ puerta = "CLOSE"

Abrir == /\ \E i \in SENSORES : SENSORES!Sensar[i]
         /\ accion = 1
         /\ UNCHANGED < puerta >

Puerta == /\ puerta = "OPEN" => puerta' = "CLOSE"
          /\ puerta = "CLOSE" => puerta' = "OPEN"
          /\ accion = 1
          /\ accion' = 0
          /\ UNCHANGED < boton >

Next == Abrir \/ Puerta

Spec == Init /\ [][Next]_vars /\ WF_vars(Puerta)

--------------------------------------------------------------

THEOREM Spec => []TypeInv

==============================================================
