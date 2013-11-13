# -*- coding: utf-8 -*-
module BeforeFilters
  def before_stub_request
    before(:each) do
      WebMock.disable_net_connect!(allow_localhost: true)

      target_url = 'http://www.google.co.jp/images/srpr/logo11w.png'
      image_file_path = "#{Rails.root}/spec/files/google_logo.png"
      # TODO: 正確なヘッダー情報が取得できるかをテストする (ex. Content-Type: "image/jpeg")
      stub_request(:get, target_url).to_return(body: File.read(image_file_path))
    end
  end
  alias_method :background_stub_request, :before_stub_request
end

RSpec.configure do |config|
  config.extend BeforeFilters, type: :view
  config.extend BeforeFilters, type: :feature
end
