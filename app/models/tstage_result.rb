#coding: utf-8
include Math
class TstageResult
  require 'property'
  attr_accessor :aa_0, :ro_0_t, :l0, :h_s, :c1, :t1, :a1, :m1, :t1_ad, :p1, :ro_1, :aa_1, :l1, :l2, :bc, :bdc, :brk, :bdrk, :lt, :gamma, :ca_1, :alfa1, :w1, :beta1, :h_l, :w2, :t2, :t2_ad, :p2, :ro_2, :aa_2, :ca_2, :beta2, :cu_2, :alfa2, :cu_1, :c2, :lu, :kpd_u, :hc, :hco, :dz_c, :h_lop, :dz_lop, :h_vyh, :dz_vyh, :c0, :a_kr_0, :t2_t, :p2_t, :h_zaz, :dz_zaz, :n_tv, :h_tv, :dz_tv, :lt, :kpd_t, :kpd_l, :kpd_tt, :h0_t, :k_g, :dt, :cp_g, :llt, :u_t1, :u_t2, :u_t0, :dt1, :dt2
  def initialize(ts, tr)
    t_0_t = ts.t_vh_t
    p_0_t = ts.p_vh_t
    r_g = 289.0
    g_g = ts.turbine.g_g
    k_g = 1.317
    @k_g = k_g
    cp_g = 1200
    @cp_g = cp_g
    epsi = 1
    c_vh = ts.c_vh
    h = ts.h
    ro = ts.ro
    phi = ts.phi ||= 0.96
    psi = ts.psi ||= 0.954
    #5.times do
      @l2 = 0
      alfa1 = ts.alfa1
      d_t = tr.d
      @dt1 = d_t
      @dt2 = d_t
      @dt = d_t
      u_t = tr.ut
      @u_t1 = u_t
      @u_t0 = u_t
      @u_t2 = u_t
      @c0 = sqrt(2*h)
      @a_kr_0 = sqrt((2*k_g*r_g*t_0_t)/(k_g+1))
      @ro_0_t = p_0_t/(r_g*t_0_t)
    # площадь на входе
      @aa_0 = g_g/(@ro_0_t*c_vh)
      @l0 = @aa_0/(Math::PI*d_t)
      @h_s = h*(1-ro)
      @c1 = phi*sqrt(2*@h_s)
      @t1 = t_0_t - ((phi**2)*@h_s)/cp_g
      @a1 = sqrt(k_g*r_g*@t1)
      @m1 = @c1/@a1
      @t1_ad = t_0_t - @h_s/cp_g
      @p1 = p_0_t*((@t1_ad/t_0_t)**(k_g/(k_g-1)))
      @ro_1 = @p1/(r_g*@t1)
      @aa_1 = g_g/(@ro_1*@c1*sin(alfa1*PI/180.0))
      @l1 = @aa_1/(PI*d_t)
      @l2 = 2.0*@l1 -@l0 if @l2 == 0
      kc = ts.kc
      kdc = ts.kdc
      krk = ts.krk
      kdrk = ts.kdrk
      @bc = @l1/kc
      @brk = @l2/krk
      @bdc = @bc*kdc
      @bdrk = @brk*kdrk
      @llt = @bc+@brk+@bdc+@bdrk
      @gamma = 2*atan((@l2-@l0)/(2*@llt))
      @gamma = @gamma*180.0/PI
      @l0 = -2*tan(@gamma*PI/360.0)*@bc + @l1
      @ca_1 = g_g/(@ro_1*@aa_1)
      @alfa1 = asin(@ca_1/@c1)*180/PI
      @w1 = sqrt(@c1**2 + u_t**2 - 2*u_t*@c1*cos(@alfa1*PI/180.0))
      @beta1 = atan(@ca_1/(@c1*cos((@alfa1*PI/180.0))-u_t))
      @beta1 = @beta1*180.0/PI
      @h_l = h*ro*@t1/@t1_ad
      @w2 = psi*sqrt(@w1**2 + 2*@h_l + @u_t2**2 - @u_t1**2)
    #@w2 = psi*sqrt(@w1**2 + 2*@h_l)
      @t2 = @t1 - (@w2**2 - @w1**2)/(2*cp_g)
      @t2_ad = @t1 - @h_l/cp_g
      @p2 = @p1*((@t2_ad/@t1)**(k_g/(k_g-1)))
    
    
    #@p2 = p_0_t*(1-((k_g-1)/(k_g+1)*(c_0/a_kr_0)**2))**(k_g/(k_g-1))
      @ro_2 = @p2/(r_g*@t2)
      @l2 = 2*tan(@gamma*PI/360.0)*(@bdc+@brk) + @l1
      @aa_2 = PI*d_t*@l2
      @ca_2 = g_g/(@aa_2*@ro_2)
      @beta2 = asin(@ca_2/@w2)*180.0/PI
      @cu_2 = @w2*cos(@beta2*PI/180.0) - u_t
      @alfa2 = atan(@ca_2/@cu_2)*180.0/PI
      @c2 = sqrt(@cu_2**2 + @ca_2**2)
      @t2_t = @t2 + (@c2**2)/(2*cp_g)
      @p2_t = @p2*((@t2_t/@t2)**(k_g/(k_g-1)))
      @cu_1 = @c1*cos(@alfa1*PI/180.0)
      #  работа на окружности колеса
      @lu = (@cu_1*@u_t1+@cu_2*@u_t2)
      @kpd_u = @lu/h
     # Потери в СА
      @hc = (phi**(-2)-1)*((@c1**2)/2.0)
      @hco = @hc*@t2_ad/@t1
      @dz_c = @hco/h
     # Потери в РК
      @h_lop = (psi**(-2)-1)*((@w2**2)/2.0)
      @dz_lop = @h_lop/h
     # Потери с выходной скоростью
      @h_vyh = (@c2**2)/2.0
      @dz_vyh = @h_vyh/h
     
      @h_zaz = 1.37*(1+1.68*ro)*(1+@l2/d_t)*@lu*0.01*@l2/@l2
      @dz_zaz = @h_zaz/h
      ro_sr = (@ro_2+@ro_0_t)/2.0
      @n_tv = (1.07*(d_t**2)+(1-epsi)*61*d_t*@l2)*ro_sr*((u_t/100)**3)
      @h_tv = @n_tv/g_g
      @dz_tv = @h_tv/h
      @lt = @lu - @h_zaz - @h_tv
      @kpd_t = @lt/h
      @kpd_l = 1.0 - @dz_c -@dz_lop - @dz_zaz - @dz_tv
      @h0_t = cp_g*t_0_t*(1 - ((@p2_t/p_0_t)**((k_g-1)/k_g)))
      @kpd_tt = @lt/@h0_t
      #cp_g = get_sr_cp((@t2_2-ts.t_vh_t)/2.0,ts.alpha)
      #k_g = cp_g/(cp_g - 289)
    #end
    #@cp_g = cp_g
    #@k_g = k_g
    ts.p_vyh_t = @p2_t
    ts.t_vyh_t = @t2_t
    ts.save
  end
  def get_sr_cp(t,alfa)
    if t < 700
      cp = (((2.25+1.2*alfa)/(alfa*100000))*(t-70)+0.236)*4187
    else
      cp = (((1.25+2.2*alfa)/(alfa*100000))*(t+450)+0.218)*4187
    end
    return cp
  end
  
end