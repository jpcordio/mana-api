class Api::V2::ArticlesController < ApplicationController
  before_action :authenticate_api_user!, except: [:index]
  before_action :set_article, only: [:show, :update, :destroy]

  # GET /articles
  def index
    # Show article for a specific user
    #@articles = current_api_user.articles.all

    # Show article for all user, for testing enable/disable boxes of the header on Insomia
    #@articles = current_api_user.article.all

    # Show all articles
    #Show articles per used_id from the most recent to the last
    #@articles = Article.order(user_id: :asc, created_at: :desc)
    @articles = Article.order(created_at: :desc)

    render json: @articles
  end

    def user_articles
      user_id = params[:user_id]
      @articles = Article.where(user_id: user_id)

      if @articles.any?
        render json: @articles
      else
        render json: { message: 'There is no post for this user' }, status: :not_found
      end
      rescue => e
        render json: { error: "Erro to load posts: #{e.message}" }, status: :internal_server_error
    end

  # GET /articles/1
  def show
    render json: @article
  end

  # POST /articles
  def create
    @article = current_api_user.articles.new(article_params)

    if @article.save
      render json: @article, status: :created, location: api_article_url(@article)
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = current_api_user.articles.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :body, :image)
    end
end
