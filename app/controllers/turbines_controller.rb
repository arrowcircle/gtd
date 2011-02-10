#coding: utf-8
class TurbinesController < ApplicationController
  # GET /turbines
  # GET /turbines.xml
  def index
    @turbines = Turbine.all
    @h = LazyHighCharts::HighChart.new('graph') do |f|
        f.options[:chart][:defaultSeriesType] = "area"
        f.options[:legend][:layout] = "horizontal"
        f.chart(:defaultSeriesType=>"spline")
        f.series(:name=>'John', :data=>[[0,0], [1,5], [2,9], [3,3], [4,-2]])
        f.series(:name=>'Jane', :data=> [[0,10], [1,15], [2,19], [3,13], [4,-12]] )
      end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @turbines }
    end
  end

  # GET /turbines/1
  # GET /turbines/1.xml
  def show
    @turbine = Turbine.find(params[:id])
    @result = TurbineResult.new(@turbine)
    
    #@turbine.t_vyh_t = @turbine.turbine_stages.last.t_vyh_t
    #@turbine.p_vyh_t = @turbine.turbine_stages.last.p_vyh_t
    #@turbine.save
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @turbine }
    end
  end

  # GET /turbines/new
  # GET /turbines/new.xml
  def new
    @turbine = Turbine.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @turbine }
    end
  end

  # GET /turbines/1/edit
  def edit
    @turbine = Turbine.find(params[:id])
  end

  # POST /turbines
  # POST /turbines.xml
  def create
    @turbine = Turbine.new(params[:turbine])

    respond_to do |format|
      if @turbine.save
        format.html { redirect_to(@turbine, :notice => 'Turbine was successfully created.') }
        format.xml  { render :xml => @turbine, :status => :created, :location => @turbine }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @turbine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /turbines/1
  # PUT /turbines/1.xml
  def update
    @turbine = Turbine.find(params[:id])

    respond_to do |format|
      if @turbine.update_attributes(params[:turbine])
        format.html { redirect_to(@turbine, :notice => 'Turbine was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @turbine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /turbines/1
  # DELETE /turbines/1.xml
  def destroy
    @turbine = Turbine.find(params[:id])
    @turbine.destroy

    respond_to do |format|
      format.html { redirect_to(turbines_url) }
      format.xml  { head :ok }
    end
  end
end
