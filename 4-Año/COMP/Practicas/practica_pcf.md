### Ejercicio 1
1. 
```text
fix(resta : N -> N -> M)(m : N).
  fun(n : N).
    ifz n then m else pred (resta m (pred n))
```

2. 
```text
fix(mult : N -> N -> N)(m : N).
  fun(n : N).
    ifz n then 0 else suma (prod m (pred n))
```

3. 
```text
fix(exp : N -> N -> N)(m : N).
  fun(n : N).
    ifz n then 1 else mult (exp m (pred n))
```
4. 
```text
fix(factorial : N -> N)(m: N).
  ifz m then 1 else mult m (factorial (pred m))
```

### Ejercicio 2
1. Podemos representar los booleanos de la siguiente manera:
```text
true = 1
false = 0
ifthenelse = fun(bool : N).
               fun(t: N). fun(f : N).
                 ifz bool then f else t
```

2. Podemos representar los pares de la siguiente manera:
```text
pair = fun(x : N).
  fun(y : N).
    fun(f : N -> N -> N).
      f x y
fst = 

```

### Ejercicio 3
```text
fix(gcd : N -> N -> N)(m : N).
  fun(n : N).
    ifz n then m else
          (ifz m then n 
                 else ifz (resta n m) then (gcd (resta m n) n)
                      else gcd m (resta n m))
```

### Ejercicio 4
```text
R = fun(z:N).
      fun(s : N -> N -> N).
        fix(f: N -> N)(n:N).
          ifz n then z else s (f n) n
```
### Ejercicio 5
```text
M = fun(f : N -> N).
      fix(min: N -> N)(n : N).
        ifz (f n) then n else (min (suc n))
        0
```
