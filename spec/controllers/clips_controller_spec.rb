require 'spec_helper'

describe ClipsController do
  let (:clip) { FactoryGirl.create(:clip) }

  before_stub_request
  before { clip }

  describe "PUT 'reclip'" do
    context "未ログインの場合" do
      it "ログインページにリダイレクトすること" do
        put :reclip, id: clip.id
        response.should redirect_to(:new_user_session)
      end
    end

    context "ログイン済みの場合" do
      before_sign_in
      it "returns http error" do
        # TODO: 正常にリクリップできるようにする
        expect { put :reclip, id: clip.id }.to raise_error(ActionView::MissingTemplate)
      end
    end
  end

  describe "PUT 'unreclip'" do
    context "未ログインの場合" do
      it "ログインページにリダイレクトすること" do
        put :reclip, id: clip.id
        response.should redirect_to(:new_user_session)
      end
    end

    context "ログイン済みの場合" do
      before_sign_in
      it "returns http error" do
        # TODO: 正常にリクリップできるようにする
        expect { put :unreclip, id: clip.id }.to raise_error(ActionView::MissingTemplate)
      end
    end
  end

  describe "XHR-PUT 'reclip'" do
    context "未ログインの場合" do
      it "ログインページにリダイレクトすること" do
        xhr :put, :reclip, id: clip.id
        response.body.should include('window.location')
        response.body.should include(new_user_session_path)
      end
    end

    context "ログイン済みの場合" do
      before_sign_in
      before { xhr :put, :reclip, id: clip.id }

      its (:response) { should be_success }
      its (:current_user) { should be_present }

      it 'リクリップに成功していること' do
        assigns[:clip].parent_id.should eq(clip.id)
      end
    end
  end

  describe "XHR-PUT 'unreclip'" do
    context "未ログインの場合" do
      it "ログインページにリダイレクトすること" do
        xhr :put, :unreclip, id: clip.id
        response.body.should include('window.location')
        response.body.should include(new_user_session_path)
      end
    end

    context "ログイン済みの場合" do
      before_sign_in
      before { xhr :put, :reclip, id: clip.id }
      before { xhr :put, :unreclip, id: clip.id }

      its (:response) { should be_success }
      its (:current_user) { should be_present }

      it 'リクリップ解除に成功していること' do
        assigns[:clip].destroyed?.should be_true
      end
    end
  end
end
