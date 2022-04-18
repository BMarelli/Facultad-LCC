---- MODULE SISTEMA ----
EXTENDS Naturals
CONSTANTS T_r, T_e, PROCESOS
ASSUME T_r, T_e  \in Nat, PROCESOS is finito
VARIABLES procesos, recurso, timers, time, running, limit

Timer == INSTANCE Timer
Timers == INSTANCE Timers

TypeInv == /\ Timer!TypeInv
           /\ recurso \in [estado: {"U", "F"}, usado: PROCESOS \cup {"null"}]
           /\ procesos \in [PROCESOS -> [op: {0,1,2,3}, count: Nat]]
           /\ \A r \in RECURSOS: recurso.estado = "F" => recurso.usado = "null"
           /\ \A r \in RECURSOS: recurso.estado = "U" => recurso.usado \in PROCESOS

vars = << procesos, recurso, timers, time, running, limit >>

------------------------
Init == /\ recurso = [estado="F", usado="null"]
        /\ \A p in PROCESOS : procesos[p] = [op=0, count=0]
        /\ \A p \in PROCESOS : Timers!Set(p, T_r)
        /\ Timer!Set(T_e)

Pedir(p) == IF recurso.estado = "U"
            THEN /\ Timers!Start(p)
                 /\ UNCHANGED << recurso, procesos, time, running, limit >> 
            ELSE /\ procesos' = [procesos EXCEPT ![p].count=0]
                 /\ recurso' = [estado="U", usado: p]
                 /\ Timer!Start()
                 /\ UNCHANGED << timers >>
Repetir(p) == /\ Timers!TimeOut(p)
              /\ IF recurso.estado = "U"
                 THEN /\ procesos' = [procesos EXCEPT ![p].count=procesos[p].count+1]
                      /\ Timers!Set(p, T_r * procesos'[p])
                      /\ Timers!Start(p)
                      /\ UNCHANGED << recursos, time, running, limit >>
                 ELSE /\ recurso' = [estado="U", usado=p]
                      /\ procesos' = [procesos EXCEPT ![p].count=0]
                      /\ Timer!Start()
                      /\ UNCHANGED << timers >>
Liberar == /\ Timer!TimeOut
           /\ LET p = procesos[recurso.usado]
              IN /\ p.op = 0
                 /\ recurso' = [estado="F", usado="null"]
                 /\ procesos' = [procesos EXCEPT ![recurso.usado].count=0]
                 /\ UNCHANGED << time, limit, running, timers >>
RealizarOp(p, n) == /\ n \in {0,1,2,3}
                    /\ procesos' = [procesos EXCEPT ![p].op=n]
                    /\ UNCHANGED << time, running, limit, timers, recurso >>

Next == \/ \E p \in PROCESOS : \/ Pedir(p)
                               \/ Repetir(p)
                               \/ \E n \in {0,1,2,3} : RealizarOp(p, n)
        \/ WF_vars(Liberar)

Spec == Init /\ [][Next]_vars

------------------------

THEOREM Spec => TypeInv

========================
