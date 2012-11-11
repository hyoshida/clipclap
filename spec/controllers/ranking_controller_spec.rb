require 'spec_helper'

describe RankingController do

  describe "GET 'views'" do
    it "returns http success" do
      get 'views'
      response.should be_success
    end
  end

  describe "GET 'likes'" do
    it "returns http success" do
      get 'likes'
      response.should be_success
    end
  end

end
