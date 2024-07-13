### Ejercicio 1
1. 
```text
fix(resta: N -> N -> N)(m: N).
  fun(n: N).
    ifz n then m else resta (pred n) (pred m)
```

2. 
```text
fix(mult: N -> N -> N)(m: N).
  fun(n: N).
    ifz n then 0 else mult (suma m m) (pred n)
```

3. 
```text
fix(exp: N -> N -> N)(m: N).
  fun(n: N).
    ifz n then 1 else exp (mult m m) (pred n)
```
4. 
```text
fix(fact: N -> N)(n: N).
  ifz n then 1 else mult n (fact (pred n))
```

### Ejercicio 2
1. Podemos representar los booleanos de la siguiente manera:
```text
true = 1
false = 0
ifthenelse = fun(bool: N).
               fun(t: N). fun(f: N).
                 ifz bool then f else t
```
(no entiendo el resto)
```text
true = fun(t: N). fun(f: N). t
false = fun(t: N). fun(f: N). f
ifthenelse = fun(bool: N).
               fun(t: N). fun(f: N).
                 bool t f
```

2. Podemos representar los pares de la siguiente manera:
```text
pair = fun(x: N).
  fun(y: N).
    fun(f : N -> N -> N).
      f x y
fst = fun(x: N). fun(t: N). x
snd = fun(y: N). fun(t: N). y
```

### Ejercicio 3
```text
fix(gcd: N -> N -> N)(m: N).
  fun(n: N).
    ifz n then m else
      ifz m then n else
        ifz (resta m n) then gcd m (resta n m) else gcd (resta m n) n
```

### Ejercicio 4
```text
R = fun(z: N).
      fun(s: N -> N -> N).
        fix(f: N -> N)(n: N).
          ifz n then z else s (f n) n
```
### Ejercicio 5
```text
M = fun(f : N -> N).
      fix(min: N -> N)(n : N).
        ifz (f n) then n else (min (suc n))
        0
```
