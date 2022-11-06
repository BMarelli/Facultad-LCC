\* Designaciones
\* - El brazo se mueve a la Izquierda == "L"
\* - El brazo se mueve a la Derecha == "R"
\* - El brazo se detiene == "STOP"
\* - El brazo esta en movimiento == accion = 0
\* - El brazo se detuvo por el boton == accion = 1
\* - El tiempo que tarda el brazo en recorrer el camino == T_ir
\* - El tiempo que tarda el brazo en cambiar la direccion por detenerse por el boton == T_det
\* - El tiempo que tarda el brazo en cambiar la direccion por llegar al limite == T_ext
\* - Timers para controlar los tiempos == timers


\* --------------------- MODULE DK_BOTON ---------------------
\* EXTENDS Naturals
\* VARIABLES boton

\* TypeInv == boton \in {0, 1}
\* vars == < boton >

\* -----------------------------------------------------------

\* Init == TypeInv
\* Click == boton' /= boton
\* Next == Click
\* Spec == Init /\ [][Next]_vars

\* -----------------------------------------------------------

\* THEOREM Spec => []TypeInv

\* ===========================================================

\* --------------------- MODULE DK_BRAZO ---------------------
\* EXTENDS Naturals
\* VARIABLES brazo

\* TypeInv == brazo \in {"L", "R", "STOP"}
\* vars == < brazo >

\* -----------------------------------------------------------

\* Init == brazo = "STOP"
\* Move == /\ brazo == "STOP"
\*         /\ CHOOSE i \in {"L", "R"} : brazo' = i
\* CambiarDireccion == \/ brazo = "L" /\ brazo' = "R"
\*                     \/ brazo = "R" /\ brazo' = "L"
\* Stop == \/ /\ brazo \in {"L", "R"}
\*            /\ brazo' = "STOP"
\* Next == Move \/ CambiarDireccion \/ Stop
\* Spec == Init => [][Next]_vars

\* -----------------------------------------------------------

\* THEOREM Spec => []TypeInv

\* ===========================================================

\* --------------------- MODULE SISTEMA ----------------------
\* EXTENDS Naturals
\* CONSTANTS T_ir, T_det, T_ext
\* VARIABLES boton, brazo, accion, timers

\* BOTON == INSTANCE DK_BOTON
\* BRAZO == INSTANCE DK_BRAZO
\* TIMERS == INSTANCE TIMERS

\* TypeInv == /\ BOTON!TypeInv
\*            /\ BRAZO!TypeInv
\*            /\ accion \in {0,1}
\* vars == < boton, brazo, accion, timers >

\* -----------------------------------------------------------

\* Init == /\ TypeInv
\*         /\ accion = 0
\*         /\ \A (i, lim) \in {(1, T_ir), (2, T_det), (3, T_ext)} : TIMERS!Set(i, lim)
\*         /\ TIMERS!Start(3)
\*         /\ BRAZO!Move

\* CambiarDireccion == /\ accion = 0
\*                     /\ TIMERS!TimeOut(1)
\*                     /\ BRAZO!CambiarDireccion
\*                     /\ TIMERS!Start(1)
\*                     /\ UNCHANGED < boton, accion >

\* PulsarDetener == /\ accion = 0
\*                  /\ BOTON!Click
\*                  /\ TIMERS!Stop(1)
\*                  /\ TIMERS!Start(2)
\*                  /\ BRAZO!Detener
\*                  /\ accion' = 1

\* PulsarContinuar == /\ accion = 1
\*                    /\ BOTON!Click
\*                    /\ TIMERS!Start(1)
\*                    /\ TIMERS!Stop(2)
\*                    /\ accion' = 0
\*                    /\ UNCHANGED < brazo >

\* CambiarDireccionExtremo == /\ accion = 0
\*                            /\ TIMERS!TimeOut(3)
\*                            /\ BRAZO!CambiarDireccion
\*                            /\ TIMERS!Start(1)
\*                            /\ accion' = 1
\*                            /\ UNCHANGED < boton >

\* Extremo == /\ accion = 1
\*            /\ TIMERS!TimeOut(1)
\*            /\ TIMERS!Start(3)
\*            /\ accion'= 0
\*            /\ UNCHANGED < boton, brazo >

\* Limite == Extremo /\ CambiarDireccion

\* Next == PulsarDetener \/ PulsarContinuar \/ CambiarDireccion \/ Limite

\* Spec == Init /\ [][Next]_vars

\* -----------------------------------------------------------

\* THEOREM Spec => []TypeInv

\* ===========================================================


\* VERSION UN SOLO MODULO

