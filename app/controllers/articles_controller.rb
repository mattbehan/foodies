class ArticlesController < ApplicationController

  include ApplicationHelper

  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :authorized_reviewer?, only: [:new, :create, :edit, :update]

  def index
    @articles = Article.order(created_at: :desc).page(params[:page]).per(5)
  end

  def new
    @article = Article.new
  end

  def create
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
    must_be_owner(@article.author_id)
  end

  def update
    must_be_owner(@article.author_id)
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
    params.require(:article).permit(:title, :content).merge(author_id: current_user.id)
  end
end
