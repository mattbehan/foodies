class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def new
    @article = Article.new
  end

  def create
    params[:article][:author_id] = 1
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article
    else
      redirect_to new_article_path
    end
  end

  def show
  end

  def edit
  end

  def update
    if @article.update_attributes(article_params)
      redirect_to @article
    else
      redirect_to edit_article_path
    end
  end

  def destroy
    @article.destroy
    redirect_to root_path
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content, :author_id)
  end
end
