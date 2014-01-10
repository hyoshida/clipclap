require 'spec_helper'

describe HomeController do
  let (:clip) { FactoryGirl.create(:clip) }

  before_stub_request
  before { clip }

  describe "GET 'index'" do
    subject { get :index }
    it { should render_template(:index) }
  end

  describe "GET 'bookmarklet'" do
    subject { get :bookmarklet }
    it { should render_template(:bookmarklet) }
  end
end
