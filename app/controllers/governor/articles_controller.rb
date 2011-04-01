class Governor::ArticlesController < ApplicationController
  # before_filter :resource, :only => [:show, :edit, ]
  before_filter :authorize_governor!, :except => [:index, :show, :find_by_date]
  # GET /articles
  # GET /articles.xml
  def index
    resources = set_resources model_class.paginate :page => params[:page], :order => 'created_at DESC'
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => resources }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    resource = set_resource model_class.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => resource }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    resource = set_resource model_class.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => resource }
    end
  end

  # GET /articles/1/edit
  def edit
    set_resource model_class.find(params[:id])
  end

  # POST /articles
  # POST /articles.xml
  def create
    resource = set_resource model_class.new(params[mapping.singular])
    resource.author = GOVERNOR_AUTHOR.call

    respond_to do |format|
      if resource.save
        flash[:notice] = "#{mapping.humanize} was successfully created."
        format.html { redirect_to(resource) }
        format.xml  { render :xml => resource, :status => :created, :location => resource }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    resource = set_resource model_class.find(params[:id])

    respond_to do |format|
      if resource.update_attributes(params[mapping.singular])
        flash[:notice] = "#{mapping.humanize} was successfully updated."
        format.html { redirect_to(resource) }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    resource = set_resource model_class.find(params[:id])
    resource.destroy

    respond_to do |format|
      format.html { redirect_to(resources_url) }
      format.xml  { head :ok }
    end
  end
  
  def find_by_date
    resources = set_resources model_class.find_all_by_date(params[:year], params[:month], params[:day], params[:page] || 1)
    
    respond_to do |format|
      format.html { render :action => 'index' }
      format.xml  { render :xml => resources }
    end
  end
  
  private
  def model_class
    @model_class ||= mapping.to
  end
  
  def set_resources(resources)
    instance_variable_set("@#{mapping.plural}", resources)
  end
  
  def set_resource(resource)
    instance_variable_set("@#{mapping.singular}", resource)
  end
  
  def resources_url
    url_for :controller => mapping.controller, :governor_mapping => params[:governor_mapping], :action => 'index'
  end
  
  def mapping
    Governor.resources[params[:governor_mapping]]
  end
  
  def authorize_governor!
    
  end
end