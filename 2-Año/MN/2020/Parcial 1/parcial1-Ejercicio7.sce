// a) Ya que estamos haciendo una division con un valor muy chico (cercano a 0)
// esto lleva a una multiplicacion muy grande 

function v = taylor_Func(f, x0, a, n, h)
  deff("y=D0F(x)", "y="+f)
  deff("y=T0F(x)", "y=D0F(a)")
  for i = 1:1:n-1
    deff("y=D"+string(i)+"F(x)", "y=(D"+string(i-1)+"F(x+h)-D"+string(i-1)+"F(x))/h")
    deff("y=T"+string(i)+"F(x)", "y=T"+string(i-1)+"F(x) + (D"+string(i)+"F(a) * (x-a)^"+string(i)+")/factorial("+string(i)+")")
  end
  deff("y=DnF(x)", "y=(D"+string(n-1)+"F(x+h)-D"+string(n-1)+"F(x))/h")
  deff("y=TnF(x)", "y=T"+string(n-1)+"F(x) + (DnF(a) * (x-a)^n)/factorial(n)")
  v = TnF(x0)
endfunction

function y = dibujar(a, b)
  x = linspace(a, b, 100)
  deff("y=f(x)", "y=(1-cos(x)^2)./x")
  y1 = f(x)
  y2 = taylor_Func("(1-cos(x)^2)/x", x, 0.1, 3, .001)
  plot(x, y1, "r", "thickness", 2)
  plot(x, y2, "g")
  legend("$f(x)$", "$taylor_Func(x)$")
  a=gca();
  a.x_location = "origin";
  a.y_location = "origin";
  y=0
endfunction
