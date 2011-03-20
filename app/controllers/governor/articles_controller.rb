class Governor::ArticlesController < ApplicationController
  # before_filter :authorize_governor, :except => [:index, :show, :find_by_date]
  # GET /articles
  # GET /articles.xml
  def index
    @articles = model_class.paginate :page => params[:page],
                                 :order => 'created_at DESC'
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = model_class.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = model_class.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = model_class.find(params[:id])
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = model_class.new(params[:article])
    # setting the author should happen here, but let's abstract this out
    # @article.author = current_user

    respond_to do |format|
      if @article.save
        flash[:notice] = 'Article was successfully created.'
        format.html { redirect_to(@article) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = model_class.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to(@article) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = model_class.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end
  
  def find_by_date
    @articles = model_class.find_all_by_date(params[:year], params[:month], params[:day], params[:page] || 1)
    
    respond_to do |format|
      format.html { render :action => 'index' }
      format.xml  { render :xml => @articles }
    end
  end
  
  private
  def model_class
    @model_class ||= Governor.resources[params[:governor_mapping]].to
  end
end
