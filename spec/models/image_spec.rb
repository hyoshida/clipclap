require 'spec_helper'

describe Image do
  describe "Validation" do
    let (:valid_image_url) { 'http://example.com/image.png' }
    let (:invalid_image_path) { 'spec/files/invalid_aspect_image.png' }
    let (:invalid_image_size) { ImageSize.new(open(invalid_image_path)) }
    let (:invalid_image) { described_class.new(url: valid_image_url, width: invalid_image_size.width, height: invalid_image_size.height) }

    it "高さが足りない場合" do
      image = invalid_image
      image.width = Settings.minimum_image_width + 1
      image.height = Settings.minimum_image_height
      image.should be_invalid
      image.errors[:height].should be_present
    end

    it "幅が足りない場合" do
      image = invalid_image
      image.width = Settings.minimum_image_width
      image.height = Settings.minimum_image_height + 1
      image.should be_invalid
      image.errors[:width].should be_present
    end

    context "アスペクト比が不正な場合" do
      it "横長すぎるためにエラーになること" do
        image = invalid_image
        image.width = Settings.allowed_image_aspect[0] * 10 + 1
        image.height = Settings.allowed_image_aspect[1] * 10
        image.should be_invalid
        image.errors[:base].should be_present
      end

      it "縦長すぎるためにエラーになること" do
        image = invalid_image
        image.width = Settings.allowed_image_aspect[1] * 10
        image.height = Settings.allowed_image_aspect[0] * 10 + 1
        image.should be_invalid
        image.errors[:base].should be_present
      end
    end

    it "アスペクト比が正しい場合" do
      image = invalid_image
      image.width = Settings.allowed_image_aspect[0] * 10
      image.height = Settings.allowed_image_aspect[1] * 10
      image.should be_valid
      image.errors[:base].should be_blank
    end
  end
end
