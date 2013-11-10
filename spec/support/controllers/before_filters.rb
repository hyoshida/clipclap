# -*- coding: utf-8 -*-
module BeforeFilters
  def before_sign_in
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:user)
    end
  end

  def before_stub_request
    before(:each) do
      target_url = 'http://www.google.co.jp/images/srpr/logo11w.png'
      image_file_path = "#{Rails.root}/spec/files/google_logo.png"
      # TODO: 正確なヘッダー情報が取得できるかをテストする (ex. Content-Type: "image/jpeg")
      stub_request(:get, target_url).to_return(body: File.read(image_file_path))
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.extend BeforeFilters, type: :controller
end
