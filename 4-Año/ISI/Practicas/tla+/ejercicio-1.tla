--------------------- MODULE DK_BOTONES ---------------------
extends Naturals
parameters
  CONSTANTS BOTONES
  ASSUME
  VARIABLES boton

  TypeInv == boton \in [ BOTONES -> {"POS1", "POS2"}]
  vars == < boton >

-------------------------------------------------------------

Init == TypeInv

Pulsar(i) == /\ boton[i]' /= boton[i]
             /\ \A j in BOTONES \ {i} : boton[j]' = boton[j]

Next == \E i \in BOTONES : Pulsar(i)

Spec == Init /\ [][Next]_vars

-------------------------------------------------------------

THEOREM Spec => []TypeInv

==============================================================


----------------------- MODULE SISTEMA -----------------------
extends Naturals
  parameters
  CONSTANTS BOTONES
  ASSUME
  VARIABLES lampara, accion, boton

  BOTONERA == INSTANCE DK_BOTONES

  TypeInv == /\ BOTONERA!TypeInv
             /\ lampara \in {"ON", "OFF"}
             /\ accion \in {0, 1}
             /\ boton \in [BOTONES -> {"POS1", "POS2"}]
  vars == < lampara, accion, boton >

--------------------------------------------------------------

Init == TypeInv /\ lampara = "OFF"

Pulsar == /\ \E i \in BOTONES : BOTONERA!Pulsar[i]
          /\ accion = 1
          /\ UNCHANGED < lampara >

Lampara == /\ lampara = "ON" => lampara' = "OFF"
           /\ lampara = "OFF" => lampara' = "ON"
           /\ accion = 1
           /\ accion' = 0
           /\ UNCHANGED < boton >

Next == Pulsar \/ Lampara

Spec == Init /\ [][Next]_vars /\ WF_vars(Lampara)

--------------------------------------------------------------

THEOREM Spec => []TypeInv

==============================================================
