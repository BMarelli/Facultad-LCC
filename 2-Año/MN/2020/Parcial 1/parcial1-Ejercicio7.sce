function v = taylor_Func(f, x0, a, n, h)
  deff("y=D0F(x)", "y="+f)
  deff("y=T0F(x)", "y=D0F(a)")
  for i = 1:1:n-1
      deff("y=D"+string(i)+"F(x)", "y=(D"+string(i-1)+"F(x+h)-D"+string(i-1)+"F(x))/h")
      deff("y=T"+string(i)+"F(x)", "y=(T"+string(i-1)+"F(x)+(D"+string(i)+"F(a) * ((x - a) ^ i))) / factorial(i)")
  end
  deff ("y=DnF(x)", "y=(D"+string(n-1)+"F(x+h)-D"+string(n-1)+"F(x))/h")
  deff("y=TnF(x)", "y=(T"+string(n-1)+"F(x)+(DnF(a) * ((x - a) ^ i))) / factorial(i)")
  v = TnF(x0)
endfunction
