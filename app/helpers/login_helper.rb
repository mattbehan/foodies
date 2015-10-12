module LoginHelper
  def login
    visit "/users/sign_in"
    fill_in 'Email', :with => User.first.email
    fill_in 'Password', :with => 'password'
    click_button 'Log in'
  end
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
