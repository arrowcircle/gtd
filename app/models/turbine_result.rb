#coding: utf-8
include Math
class TurbineResult
  attr_accessor :t2, :ro2t, :ro2, :p2, :aa2, :nmax, :pi_t, :pi_tt, :h, :d, :l2, :c0, :ut, :c2sr, :z, :hh
  def initialize(t)
    cp_g = 1210
    r_g = 289.0
    sig_lop = 390000000
    k_n = 6.8*0.000001
    g_g = t.g_g
    k_g = 1.3
    
    @t2 = t.t_vyh_t - (t.cta**2)/(2.0*cp_g)
    @ro2t = t.p_vyh_t/(r_g*t.t_vyh_t)
    @p2 = t.p_vyh_t - @ro2t*(t.cta**2)/(2.0*cp_g)
    @ro2 = @p2/(r_g*@t2)
    @aa2 = g_g/(@ro2*t.cta)
    @nmax = sqrt(sig_lop/(k_n*@aa2*1000000))
    @pi_t = t.p_vh_t / @p2
    @pi_tt = t.p_vh_t/t.p_vyh_t
    @h = cp_g*t.t_vh_t*(1-(@pi_t)**((1-k_g)/k_g))
    @d = sqrt(@aa2/(PI*t.x))
    @ut = t.n*@d*PI/(2.0*30)
    @l2 = @aa2/(PI*@d)
    @c0 = sqrt(2*@h)
    @c2sr = sqrt(0.5*(t.c2usl**2 + t.cta**2)) 
    verh = (1+t.alfa)*(@c0**2)
    verh = verh/((t.mju*@c2sr)**2)
    verh = verh - 1
    niz = @ut**2
    niz = niz /(t.y0**2)
    niz = niz/((t.mju*@c2sr)**2)
    niz = niz - 1
    @z = verh/niz
    @hh = []
    h1 = @h*(1+t.alfa)*(@ut**2)
    h1 = h1 / (z*(@ut**2))
    h1 = h1 + 0.5*t.mju*(t.c2usl**2)
    @hh << h1
    if @z.to_i > 1
      (2..z-1).to_a.each do |a|
        h = (1+t.alfa)*@hh.last
        @hh << h
      end
    end
    hsum = 0
    @hh.each {|p| hsum += p} 
    h = -(1+t.alfa*@h) + hsum
    @hh << h
    
    
    
  end
end