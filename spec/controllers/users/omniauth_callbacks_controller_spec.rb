require 'spec_helper'

describe Users::OmniauthCallbacksController do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:facebook, facebook_auth_attributes)

    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  describe "POST 'facebook'" do
    before { post :facebook }

    context "ログインできた場合" do
      let (:facebook_auth_attributes) { valid_facebook_auth_attributes }

      it { expect(response).to redirect_to root_url }

      it "ログイン成功のメッセージが表示されること" do
        expect(flash[:notice]).to be
      end
    end

    context "ログインできなかった場合" do
      # TODO: データ構造が正しくない場合に例外が発生する問題の解消
      let (:facebook_auth_attributes) { { extra: { raw_info: { name: 'hoge' } } } }

      it { expect(response).to redirect_to new_user_registration_url }
    end
  end

  private

  def valid_facebook_auth_attributes(attributes={})
    attributes.merge(
      uid: 1234,
      credentials: {
        token: 'foo-token'
      },
      info: {
        email: 'foobar@example.com'
      },
      extra: {
        raw_info: {
          name: '山田太郎'
        }
      }
    )
  end
end
