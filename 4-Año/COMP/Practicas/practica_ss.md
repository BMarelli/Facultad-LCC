### Ejercicio 1
1. `let (x : Nat) = 2 in succ x`
2. `fun (x Nat) -> x`
3. `let (id : Nat -> Nat) = fun (x : Nat) -> x in id 10`
4. `let (app5 : Nat -> Nat -> Nat) = fun (f : Nat -> Nat) -> f 5 in app5 succ`
5. `fun (x : Nat) -> fun (y : Nat) -> ifz x then y else 1`

### Ejercicio 2
1. 
```text
let (double : Nat -> Nat) = fix (double : Nat -> Nat) (x : Nat) -> ifz x then 0 else succ (succ (double (pred x)))
```
2. 
```text
let rec ack (n : Nat) : Nat -> Nat = fun (m : Nat) -> ifz m then succ n else (ifz n then ack (pred m) 1 else ack (pred m) (ack m (pred n)))
= { def }
let ack : Nat -> Nat -> Nat = fix (ack : Nat -> Nat -> Nat) (n : Nat) -> fun (m : Nat) -> ifz m 
                                                                                          then succ n 
                                                                                          else (ifz n 
                                                                                                then ack (pred m) 1 
                                                                                                else ack (pred m) (ack m (pred n)))
```
