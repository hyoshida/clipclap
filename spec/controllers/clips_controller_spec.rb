require 'spec_helper'

describe ClipsController do
  let (:clip) { FactoryGirl.create(:clip) }

  before_stub_request

  describe "GET 'show'" do
    let (:request) { get :show, id: clip.id }

    render_views

    context "未ログインの場合" do
      before { request }
      its (:response) { should be_success }
    end

    context "ログイン済みの場合" do
      before_sign_in
      before { request }
      its (:response) { should be_success }
    end
  end

  describe "PUT 'create'" do
    context "未ログインの場合" do
      it "ログインページにリダイレクトすること" do
        put :reclip, id: clip.id
        response.should redirect_to(:new_user_session)
      end
    end

    context "ログイン済みの場合" do
      let (:image_url) { 'http://example.com/image.png' }
      let (:image_path) { "#{Rails.root}/spec/files/rectangle.png" }
      let (:clip_attributes) { { clip: { title: 'クリップ', url: image_url, origin_url: image_url } } }

      before_sign_in
      before { stub_request(:get, image_url).to_return(body: File.read(image_path)) }
      before { post :create, clip_attributes }

      its (:response) { should redirect_to clip_path(assigns[:clip]) }
      its (:current_user) { should be_present }

      it 'クリップの保存に成功していること' do
        assigns[:clip].persisted?.should be_true
      end
    end
  end

  describe "PUT 'reclip'" do
    before { clip }

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
