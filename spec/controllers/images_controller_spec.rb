require 'spec_helper'

describe ImagesController do
  let (:image) { FactoryGirl.create(:image) }
  let (:minimagick_image) { MiniMagick::Image.read(response.body) }

  before_stub_request
  before { image }
  # あらかじめサムネイルのキャッシュファイルを削除しておく
  before { File.delete image.thumb_path if File.exist? image.thumb_path }

  describe "GET 'show'" do
    context "通常画像の場合" do
      before { get :show, id: image.id }

      its (:response) { should be_success }

      it "幅が正しいこと" do
        expect(minimagick_image[:width]).to eq(image.width)
      end

      it "高さが正しいこと" do
        expect(minimagick_image[:height]).to eq(image.height)
      end
    end

    context "サムネイル画像の場合" do
      before { get :show, id: image.id, type: :thumbnail }
      its (:response) { should be_success }

      it "幅が正しいこと" do
        expect(minimagick_image[:width]).to eq(image.thumb_width)
      end

      it "高さが正しいこと" do
        expect(minimagick_image[:height]).to eq(image.thumb_height)
      end
    end
  end
end
