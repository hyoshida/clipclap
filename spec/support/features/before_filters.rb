# -*- coding: utf-8 -*-
module BeforeFilters
  def sign_in_as(user, options={})
    Warden.test_mode!
    login_as(user, scope: :user, run_callbacks: false)
  end
end

RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :feature
  config.include BeforeFilters, type: :feature
end
