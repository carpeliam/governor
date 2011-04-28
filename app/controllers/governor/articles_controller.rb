class Governor::ArticlesController < ApplicationController
  include Governor::Controllers::Helpers
  include Governor::Controllers::Methods
  before_filter :init_resource, :only => [:show, :edit, :update, :destroy]
  before_filter :authorize_governor!, :only => [:new, :edit, :create, :update, :destroy]
  helper :governor
  
  helper Governor::Controllers::Helpers
  
  respond_to :html
  Governor::PluginManager.plugins.each do |plugin|
    plugin.mimes.each{|mimes| respond_to *mimes.dup }
  end
  
  # GET /articles
  # GET /articles.xml
  def index
    set_resources(if model_class.respond_to?(:paginate)
      model_class.paginate :page => params[:page], :order => 'created_at DESC'
    else
      model_class.all :order => 'created_at DESC'
    end)
    respond_with resources
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    respond_with resource
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    set_resource model_class.new
    respond_with resource
  end

  # GET /articles/1/edit
  def edit
    respond_with resource
  end

  # POST /articles
  # POST /articles.xml
  def create
    set_resource model_class.new(params[mapping.singular])
    resource.author = the_governor
    if resource.save
      flash[:notice] = "#{mapping.humanize} was successfully created."
    end
    respond_with resource
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    if resource.update_attributes(params[mapping.singular])
      flash[:notice] = "#{mapping.humanize} was successfully updated."
    end
    respond_with resource
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    resource.destroy
    flash[:notice] = "#{mapping.humanize} was successfully updated."
    respond_with resource
  end
  
  def find_by_date
    set_resources model_class.find_all_by_date(params[:year], params[:month], params[:day], params[:page] || 1)
    
    respond_to do |format|
      format.html { render :action => 'index' }
      format.xml  { render :xml => resources }
    end
  end
end