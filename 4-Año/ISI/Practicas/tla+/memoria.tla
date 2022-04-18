--------------------- MODULE PROCESADOR ---------------------
EXTENDS Naturals
CONSTANT Data
ASSUME null \in Data
VARIABLES val, req, rdy

TypeInv == /\ val \in Data
           /\ req \in [type: {"R", "W"}, mem: Nat]
        \* /\ req \in [type \in {"R", "W"}, mem: Nat] 
           /\ rdy \in {0,1}
vars == << val, req, rdy >>

-------------------------------------------------------------

Init == TypeInv /\ val = null
makeRequest(r, i) == /\ rdy = 1
                     /\ i \in Nat
                     /\ req' = [type=r, mem=i]
                     /\ rdy' = 0
                     /\ UNCHANGED val
procResponse(res) == /\ res \in Data
                     /\ rdy = 0
                     /\ val' = res
                     /\ rdy' = 1
                     /\ UNCHANGED req

Next == \/ \E r \in {"R", "W"}, i \in Nat : makeRequest(r, i)
        \/ \E res \in Data : procResponse(res)

Spec == Init /\ [][Next]_vars

-------------------------------------------------------------

THEOREM Spec => []TypeInv

=============================================================


--------------------- MODULE MEMORIA ---------------------
EXTENDS Naturals, Sequences
==========================================================
