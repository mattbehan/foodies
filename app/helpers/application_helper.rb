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

end

# devise comes wit the methods:
# current_user - returns the current user
# user_signed_in - same as authenticated?
#sign_in(@user) and sign_out(@user) - devise created methods that will either sign users in our out
# user_session - returns metadata... by and large DO NOT USE
