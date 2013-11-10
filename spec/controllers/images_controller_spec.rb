require 'spec_helper'

describe ImagesController do
  let (:image) { FactoryGirl.create(:image) }

  before_stub_request
  before { image }
  # あらかじめサムネイルのキャッシュファイルを削除しておく
  before { File.delete image.thumb_path if File.exist? image.thumb_path }

  describe "GET 'show'" do
    it "returns http success" do
      get :show, id: image.id
      response.should be_success
    end
  end
end
