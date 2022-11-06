--------------------- MODULE DK_SENSOR ----------------------
extends Naturals
parameters
  CONSTANTS SENSORES
  ASSUME
  VARIABLES sensor

  TypeInv == sensor \in [SENSORES -> Nat \cup {"FALLO"}]
  vars == < sensor >

-------------------------------------------------------------

Init == TypeInv /\ \A i in SENSORES : sensor[i] = 0

Senso(i) == CHOOSE x \in Nat \cup {"FALLO"} : sensor[i] = x

Next == \E i in SENSORES : Senso(i)

Spec == Init /\ [][Next]_vars

-------------------------------------------------------------

THEOREM Spec => []TypeInv

=============================================================

-------------------- MODULE DK_PANTALLA ---------------------
extends Naturals
parameters
  CONSTANTS Show(_) /* Muestra en pantalla, return True
  ASSUME
  VARIABLES text

  TypeInv == text \in {"OK", "FALLO", "PELIGRO"}
  vars == < text >

-------------------------------------------------------------

Init == TypeInv

MostrarOk == /\ text = "OK"
             /\ Show(text)

MostrarPeligro == /\ text = "PELIGRO"
                  /\ Show(text)

MostrarFallo == /\ text = "FALLO"
                /\ Show(text)

Next == MostrarOk \/ MostrarPeligro \/ MostrarFallo

Spec == Init /\ [][Next]_vars

-------------------------------------------------------------

THEOREM Spec => []TypeInv

=============================================================


---------------------- MODULE SISTEMA -----------------------
extends Naturals
parameters
  CONSTANTS SENSORES
  ASSUME
  VARIABLES sensor, accion, error, min, max, text

  SENSOR == INSTANCE SENSOR

  TypeInv == /\ SENSOR!TypeInv
             /\ error \in {0, 1}
             /\ min, max \in Nat
             /\ text \in {"OK", "PELIGRO", "FALLO"}
  vars == < sensor, accion, error, min, max, text >

-------------------------------------------------------------

Init == /\ SENSOR!Init
        /\ CHOOSE i, j \in Nat : /\ i < j
                                 /\ min = i
                                 /\ max = j

Comparar(v) == IF v = "FALLO" THEN error' = 1 /\ text' = "FALLO"
               ELSE IF min <= v <= max THEN error' = 0 /\ text' = "OK"
                   ELSE error' = 1 /\ text' = "PELIGRO"

MedirOk(i) == /\ accion = 0
              /\ SENSOR!Sensar[i]
              /\ Comparar(SENSOR!sensor[i])
              /\ error' = 0
              /\ accion' = 1

MedirError(i) == /\ accion = 0
                 /\ SENSOR!Sensar[i]
                 /\ Comparar(SENSOR!sensor[i])
                 /\ error' = 1
                 /\ accion' = 1

Medir == \E i \in SENSORES : MedirOk(i) \/ MedirError(i)

Pantalla == /\ accion = 1
            /\ Show(text)

Next == Medir \/ Pantalla

Spec == Init /\ [][Next]_vars /\ WF_vars(Pantalla)

-------------------------------------------------------------

THEOREM Spec => []TypeInv

=============================================================
