class AddIndexes < ActiveRecord::Migration
  def change
    add_index(:restaurants, :name)
    add_index(:restaurants, :cuisine)
    add_index(:restaurants, :neighborhood)
    add_index(:restaurants, :zip)
    add_index(:restaurants, :city)
    add_index(:restaurants, :state)
    add_index(:votes, :votable_id)
    add_index(:votes, :user_id)
    add_index(:articles, :author_id)
    add_index(:taggings, :restaurant_id)
    add_index(:taggings, :tag_id)
    add_index(:specialties, :restaurant_id)
    add_index(:specialties, :dish_id)
    add_index(:comments, :user_id)
    add_index(:comments, :review_id)
    add_index(:reviews, :restaurant_id)
    add_index(:reviews, :reviewer_id)
    add_index(:quick_takes, :rater_id)
    add_index(:quick_takes, :restaurant_id)
    add_index(:visits, :visited_restaurant_id)
    add_index(:visits, :visitor_id)
    add_index(:bookmarks, :bookmarker_id)
    add_index(:bookmarks, :bookmarked_restaurant_id)
    add_index(:followings, :followed_user_id)
    add_index(:followings, :follower_id)
    add_index :dishes, :name, unique: true
    add_index :tags, :name, unique: true
  end
end
