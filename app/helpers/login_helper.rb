module LoginHelper
  def login
    visit "/users/sign_in"
    fill_in 'Email', :with => User.first.email
    fill_in 'Password', :with => 'password'
    click_button 'Log in'
  end
end
