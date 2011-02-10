#coding: utf-8
class Turbine
  include Mongoid::Document
  references_many :turbine_stages, :dependent => :destroy
  field :t_vh_t, :type => Float
  field :p_vh_t, :type => Float
  field :p_vyh_t, :type => Float
  field :t_vyh_t, :type => Float
  field :kpd_meh, :type => Float, :default => 0.995
  field :g_g, :type => Float
  field :n_k, :type => Integer
  field :n, :type => Integer
  field :cta, :type => Integer
  field :c2usl, :type => Integer
  field :x, :type => Float, :default => 5.0
  field :mju, :type => Float, :default => 0.95
  field :alfa, :type => Float, :default => 0.02
  field :y0, :type => Float, :default => 0.6
  field :alpha, :type => Float, :default => 2.0
  after_save :set_stages
  
  def set_stages
    #self.turbine_stages.each {|ts| ts.destroy}
    @result = TurbineResult.new(self)
    if self.turbine_stages.to_a.empty?
      a =  self.turbine_stages.build(:p_vh_t => self.p_vh_t, :t_vh_t => self.t_vh_t, :c_vh => @result.c2sr, :h =>@result.hh[0], :ro => 0.3, :phi => 0.97, :psi => 0.97, :alfa1 => 24, :kc => 2.0, :kdc => 0.2, :krk => 3.0, :kdrk => 0.3 )
      TstageResult.new(a,@result)
    end
    diff = (@result.hh.count - self.turbine_stages.count)
    if diff > 0
      diff.times do
        a = self.turbine_stages.build(:p_vh_t => self.turbine_stages.last.p_vyh_t, :t_vh_t => self.turbine_stages.last.t_vyh_t, :c_vh => @result.c2sr, :h =>@result.hh[self.turbine_stages.count], :ro => 0.3, :phi => 0.97, :psi => 0.97, :alfa1 => 24, :kc => 2.0, :kdc => 0.2, :krk => 3.0, :kdrk => 0.3 )
        TstageResult.new(a,@result)
      end
    elsif diff < 0
      diff = (-1)*diff
      diff.times do
        self.turbine_stages.to_a.last.destroy
      end
    end
    @result.hh[1..-1].each do |h|
      a = self.turbine_stages.to_a[@result.hh.index(h)]
      a.update_attributes(:p_vh_t => self.turbine_stages.to_a[@result.hh.index(h)-1].p_vyh_t, :t_vh_t => self.turbine_stages.to_a[@result.hh.index(h)-1].t_vyh_t, :c_vh => @result.c2sr, :h =>h, :ro => 0.3, :phi => 0.97, :psi => 0.97, :alfa1 => 24, :kc => 2.0, :kdc => 0.2, :krk => 3.0, :kdrk => 0.3 )
      TstageResult.new(a,@result)
      #a.save
      #self.save
    end
  end
end