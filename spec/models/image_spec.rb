require 'spec_helper'

describe Image do
  describe "Validation" do
    let (:valid_image_url) { 'http://example.com/image.png' }
    let (:invalid_image_path) { 'spec/files/invalid_aspect_image.png' }
    let (:invalid_image_size) { ImageSize.new(open(invalid_image_path)) }
    let (:invalid_image) { described_class.new(url: valid_image_url, width: invalid_image_size.width, height: invalid_image_size.height) }

    it "高さが足りない場合" do
      image = invalid_image
      image.width = 17
      image.height = 16
      image.should be_invalid
      image.errors[:height].should be_present
    end

    it "幅が足りない場合" do
      image = invalid_image
      image.width = 16
      image.height = 17
      image.should be_invalid
      image.errors[:width].should be_present
    end

    it "アスペクト比が不正な場合" do
      image = invalid_image
      image.width *= 100
      image.height *= 100
      image.should be_invalid
      image.errors[:base].should be_present
    end
  end
end
