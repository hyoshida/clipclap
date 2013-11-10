require 'spec_helper'

describe ImagesController do
  let (:image) { FactoryGirl.create(:image) }

  before { image }

  describe "GET 'show'" do
    it "returns http success" do
      get :show, id: image.id
      response.should be_success
    end
  end
end
