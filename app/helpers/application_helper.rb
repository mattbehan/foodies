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
      "http://38.media.tumblr.com/avatar_f947f46a1351_128.gif",
      "http://33.media.tumblr.com/avatar_bfee0d75c453_128.png",
      "https://38.media.tumblr.com/avatar_afd27060913e_128.png",
      "https://djuf8khon03er.cloudfront.net/wp-content/uploads/2012/09/carrot_rosemary_soup_2_from_Kitchen_Counter_by_Kathleen_Flinn-128x128.jpg"
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
