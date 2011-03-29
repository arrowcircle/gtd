#coding: utf-8
include Math
class TurbineResult
  attr_accessor :t2, :ro2t, :ro2, :p2, :aa2, :nmax, :pi_t, :pi_tt, :h, :d, :l2, :c0, :ut, :c2sr, :z, :hh
  def initialize(t)
    r_g = 289.0
    sig_lop = 390000000
    k_n = 6.8*0.000001
    g_g = t.g_g
    t_sr = (t.t_vyh_t + t.t_vh_t)/2
    cp_g = get_sr_cp(t_sr, t.alpha)
    k_g = cp_g/(cp_g - r_g)
    
    @t2 = t.t_vyh_t - (t.cta**2)/(2.0*cp_g)
    @ro2t = t.p_vyh_t/(r_g*t.t_vyh_t)
    #@p2 = t.p_vyh_t - @ro2t*(t.cta**2)/(2.0*cp_g)
    @p2 = t.p_vyh_t*((t.t_vyh_t/@t2)**(k_g/(1-k_g)))
    @ro2 = @p2/(r_g*@t2)
    @aa2 = g_g/(@ro2*t.cta)
    @nmax = sqrt(sig_lop/(k_n*@aa2*1000000))
    @pi_t = t.p_vh_t/@p2
    @pi_tt = t.p_vh_t/t.p_vyh_t
    @h = cp_g*t.t_vh_t*(1-(@pi_t)**((1-k_g)/k_g))
    #@ut = t.y0*
    #@d = sqrt(@aa2/(PI*t.x))
    #@ut = t.n*@d*PI/(2.0*30)
    
    @c0 = sqrt(2*@h)
    @ut = t.y0*@c0
    @d = @ut*60/(PI*t.n)
    @l2 = @aa2/(PI*@d)
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
  
  private
  def get_sr_cp(t,alfa)
    if t < 750
      cp = (0.0174/alfa + 0.2407 +(0.0193+0.0093/alfa)*(0.001*2.5*t -0.875) + (0.002 - 0.001*1.056/(alfa - 0.2))*(2.5*0.00001*t**2 - 0.0275*t + 6.5625))*4187
    else
      cp = (0.0267/alfa + 0.26+(0.032 + 0.0133/alfa)*(0.001*1.176*t-0.88235) - (0.374*0.01 + 0.0094/(alfa**2+10))*(5.5556*0.000001*t**2 - 1.3056*0.01*t+6.67))*4187
    end
    return cp
  end
end