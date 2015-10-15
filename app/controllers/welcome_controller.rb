class WelcomeController < ApplicationController

  def index
    # Refactor to featured stuff based on algorithm later
    @restaurant = Restaurant.find_by(id: 2) || Restaurant.all.sample
    @review = Review.all.sample
    @article = Article.all.sample
  end

  def splash
  	render :splash, layout: false
  end

end
