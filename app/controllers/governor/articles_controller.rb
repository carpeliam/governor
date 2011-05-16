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
    # if plugins modify default scope, show everything if user is logged in
    collection = governor_logged_in? ? model_class.unscoped : model_class
    set_resources(if model_class.respond_to?(:paginate)
      collection.paginate :page => params[:page], :order => 'created_at DESC'
    else
      collection.all :order => 'created_at DESC'
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
      flash[:notice] = t('governor.article_created', :resource_type => mapping.humanize)
    end
    respond_with resource
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    if resource.update_attributes(params[mapping.singular])
      flash[:notice] = t('governor.article_updated', :resource_type => mapping.humanize)
    end
    respond_with resource
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    resource.destroy
    flash[:notice] = t('governor.article_destroyed', :resource_type => mapping.humanize)
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