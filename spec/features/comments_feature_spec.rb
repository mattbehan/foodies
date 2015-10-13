require 'capybara/rails'
require 'rails_helper'
require 'spec_helper'
require 'login_helper'

include LoginHelper
# include WaitForAjax

def wait_for_ajax
  counter = 0
  while page.execute_script("return $.active").to_i > 0
    counter += 1
    sleep(0.1)
    raise "AJAX request took longer than 5 seconds." if counter >= 50
  end
end
