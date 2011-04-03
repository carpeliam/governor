class Governor::ArticlesController < ApplicationController
  include Governor::Controllers::Helpers
  before_filter :init_resource, :only => [:show, :edit, :update, :destroy]
  before_filter :authorize_governor!, :only => [:new, :edit, :create, :update, :destroy]
  helper :governor
  helper Governor::Controllers::Helpers
  
  # GET /articles
  # GET /articles.xml
  def index
    set_resources model_class.paginate :page => params[:page], :order => 'created_at DESC'
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => resources }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => resource }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    set_resource model_class.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => resource }
    end
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.xml
  def create
    set_resource model_class.new(params[mapping.singular])
    resource.author = the_governor

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
    resource.destroy

    respond_to do |format|
      format.html { redirect_to(resources_url) }
      format.xml  { head :ok }
    end
  end
  
  def find_by_date
    set_resources model_class.find_all_by_date(params[:year], params[:month], params[:day], params[:page] || 1)
    
    respond_to do |format|
      format.html { render :action => 'index' }
      format.xml  { render :xml => resources }
    end
  end
end