require 'spec_helper'

describe MatomesController do
  let (:matome) { FactoryGirl.create(:matome) }

  before { matome }

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get :show, id: matome.id
      response.should be_success
    end
  end
end
