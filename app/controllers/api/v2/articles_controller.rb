class Api::V2::ArticlesController < ApplicationController
  before_action :authenticate_api_user!, except: [:index]
  before_action :set_article, only: [:show, :update, :destroy]

  # GET /articles
  def index
    @articles = current_api_user.article.all

    render json: @articles
  end

  # GET /articles/1
  def show
    render json: @article
  end

  # POST /articles
  def create
    @article = current_api_user.article.new(article_params)

    # The api_article_url was added because I added the api on the address
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
      @article = current_api_user.article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :body, :image)
    end
end
