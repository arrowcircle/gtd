#coding: utf-8
class TurbineStage
  include Mongoid::Document
  field :t_vh_t, :type => Float
  field :p_vh_t, :type => Float
  field :t_vyh_t, :type => Float
  field :p_vyh_t, :type => Float
  field :c_vh, :type => Float
  field :h, :type => Float
  field :ro, :type => Float, :default => 0.3
  field :phi, :type => Float, :default => 0.97
  field :psi, :type => Float, :default => 0.97
  field :alfa1, :type => Float, :default => 24.0
  # коэффициенты для ширины и зазора
  field :kc, :type => Float, :default => 2.0
  field :kdc, :type => Float, :default => 0.2
  field :krk, :type => Float, :default => 3.0
  field :kdrk, :type => Float, :default => 0.3
  referenced_in :turbine, :inverse_of => :turbine_stages
  
  #after_save :rebuild_stages
  
  def rebuild_stages
    stages = self.turbine.turbine_stages.to_a
    unless stages.index(self) == stages.count-1
      tst = stages[stages.index(self)+1]
      tst.t_vh_t = self.t_vyh_t
      tst.p_vh_t = self.p_vyh_t
      tst.save
      TstageResult.new(tst, TurbineResult.new(self.turbine))
      tst.rebuild_stages
    else
    end
  end  
end
