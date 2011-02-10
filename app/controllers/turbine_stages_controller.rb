#coding: utf-8
class TurbineStagesController < ApplicationController
  def index
    @tstages = TurbineStage.all
  end

  def new
    @tstage = TurbineStage.new
  end

  def create
    @tstage = TurbineStage.new(params[:turbine_stage])
    if @tstage.save
      redirect_to turbine_path(@tstage.turbine)
    else
      render "new", :notice => "Error creating turbine stage"
    end
  end

  def show
    @tstage = TurbineStage.find(params[:id])
    @result = TstageResult.new(@tstage)
  end

  def edit
    @tstage = TurbineStage.find(params[:id])
  end

  def update
    @tstage = TurbineStage.find(params[:id])
    if @tstage.update_attributes(params[:turbine_stage])
      @tstage.rebuild_stages
      redirect_to turbine_path(@tstage.turbine)
    else
      render "edit", :notice => "Error updating turbine stage"
    end
  end

  def destroy
    @tstage = TurbineStage.find(params[:id])
    @tstage.destroy
    redirect_to turbine_path(@tstage.turbine), :notice => "turbine stage deleted"
  end

end
