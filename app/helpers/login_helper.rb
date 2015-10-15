
module LoginHelper
  def login
    visit "/users/sign_in"
    fill_in 'Email', :with => User.first.email
    fill_in 'Password', :with => 'password'
    click_button 'Log in'
  end

  def login_as_user
    visit "/users/sign_in"
    user = User.find_by(role: "user")
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log in"
  end
end

def login_as_invalid
  visit "/users/sign_in"
  fill_in "Email", with: ("a".."z").to_a.shuffle[0..8].join("").concat("@email.com")
  fill_in "Password", with: ("a".."z").to_a.shuffle[0..12].join("")
  click_button "Log in"
end

module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end
