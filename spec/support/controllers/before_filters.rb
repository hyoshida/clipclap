# -*- coding: utf-8 -*-
module BeforeFilters
  def before_sign_in
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:user)
    end
  end
end

RSpec.configure do |config|
  config.extend BeforeFilters, type: :controller
end
