 module ApplicationHelper

  def authorized_reviewer?
    redirect_to new_user_session_path unless current_user && current_user.reviewer?
  end

  def authorized_admin?
    redirect_to new_user_session_path unless current_user && current_user.admin?
  end

  def admin_or_reviewer?
    redirect_to new_user_session_path unless current_user && (current_user.admin? || current_user.reviewer?)
  end

  def review_creator?
    redirect_to @restaurant unless current_user && @review.reviewer_id == current_user.id
  end

  def avatar_url(user)
    food_photos = [
      "http://cdn1.medicalnewstoday.com/content/images/articles/271157-bananas.jpg",
      "http://www.freefoodphotos.com/imagelibrary/breakfast/slides/egg_and_bacon.jpg",
      "http://www.freefoodphotos.com/imagelibrary/breakfast/slides/croissants.jpg",
      "http://www.freefoodphotos.com/imagelibrary/meals/slides/pizza.jpg",
      "https://images.unsplash.com/photo-1426869981800-95ebf51ce900?q=80&fm=jpg&s=2c89e023814a3fdb98edc129cf1357c2",
      "https://images.unsplash.com/photo-1426869884541-df7117556757?q=80&fm=jpg&s=a96e2a65771dd939883420703a0bb928",
      "https://images.unsplash.com/photo-1432752641289-a25fc853fceb?q=80&fm=jpg&s=845db824014f34ca56b05451725e9270"
    ]
    default_url = food_photos.sample
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=150&d=#{CGI.escape(default_url)}"
  end

  def humanize_boolean(boolean)
    boolean ? "Yes" : "No"
  end

end

# devise comes wit the methods:
# current_user - returns the current user
# user_signed_in - same as authenticated?
#sign_in(@user) and sign_out(@user) - devise created methods that will either sign users in our out
# user_session - returns metadata... by and large DO NOT USE
