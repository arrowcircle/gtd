#coding: utf-8
class TurbineStagesController < ApplicationController
  before_filter :find_turbine
  def index
    @tstages = @turbine.turbine_stages.all
  end

  def new
    @tstage = @turbine.turbine_stages.build
    if @turbine.turbine_stages.count > 0 
      @tstage.p_vh_t = @turbine.turbine_stages[-2].p_vh_t
      @tstage.t_vh_t = @turbine.turbine_stages[-2].t_vh_t
    else
      @tstage.p_vh_t = @turbine.p_vh_t
      @tstage.t_vh_t = @turbine.t_vh_t
    end
  end

  def create
    @tstage = @turbine.turbine_stages.build(params[:turbine_stage])
    if @tstage.save
      @result = TstageResult.new(@tstage)
      redirect_to turbine_path(@tstage.turbine)
    else
      render "new", :notice => "Error creating turbine stage"
    end
  end

  def show
    @tstage = @turbine.turbine_stages.find(params[:id])
    @result = TstageResult.new(@tstage)
  end

  def edit
    @tstage = @turbine.turbine_stages.find(params[:id])
  end

  def update
    @tstage = @turbine.turbine_stages.find(params[:id])
    if @tstage.update_attributes(params[:turbine_stage])
      @result = TstageResult.new(@tstage)
      @tstage.rebuild_stages
      redirect_to turbine_path(@tstage.turbine)
    else
      render "edit", :notice => "Error updating turbine stage"
    end
  end

  def destroy
    @tstage = TurbineStage.find(params[:id])
    @tstage.destroy
    redirect_to turbine_path(@turbine), :notice => "turbine stage deleted"
  end
  
  private
  
  def find_turbine
    @turbine = Turbine.find(params[:turbine_id])
  end

end
