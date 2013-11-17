require 'spec_helper'

describe HomeController do
  let (:clip) { FactoryGirl.create(:clip) }

  before_stub_request
  before { clip }

  describe "GET 'index'" do
    subject { get :index }

    context "未ログインの場合" do
      it "ゲスト向けのページが描画されること" do
        expect(subject).to render_template(:guest)
      end
    end

    context "ログイン済みの場合" do
      before_sign_in

      it "ログインユーザー向けのページが描画されること" do
        expect(subject).to render_template(:index)
      end
    end
  end
end
