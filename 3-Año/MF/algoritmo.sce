function vn = algoritmo(m, xn, dx)
    x = 0
    vcuad(1) = 0
    deff("y=R(r)", "y=(19.6) - ((2000/m)*r)")
    FR(1) = R(0)
    
    i = 2
    while x <= xn
      d_vcuad = dx * FR(i-1)
      vcuad(i) = vcuad(i-1) + d_vcuad
      v(i) = sqrt(vcuad(i))
      r_ = (46 * 10^-3) * vcuad(i)
      
      FR(i) = R(r_)
      
      x = x + dx
      i = i + 1
    end
    
    vn = v(i - 1)
endfunction
