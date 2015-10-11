class WelcomeController < ApplicationController

  def index
    # Refactor to featured stuff based on algorithm later
    @restaurant = Restaurant.all.sample
    @review = Review.all.sample
    @article = Article.all.sample
  end

end
