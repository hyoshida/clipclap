require 'spec_helper'

describe ImageClipper do
  let(:user) { FactoryGirl.create(:user) }
  let(:page_url) { 'http://example.com' }
  let(:image_url) { 'http://example.com/image.jpg' }
  let(:html_cache_path) { File.join(Settings.html_cache_dir, "#{user.id}.html") }

  before { delete_html_cache_file }

  describe "正常系" do
    before { stub_for_private_pub }

    context "ページURLが渡された場合" do
      before do
        stub_for_page_url
        described_class.perform(user.id, page_url)
      end

      it "キャッシュファイルが生成されていること" do
        File.exist?(html_cache_path).should be_true
      end

      it "１つのimgタグを含むこと" do
        html = File.open(html_cache_path).read
        (Hpricot(html)/:img).count.should eq(1)
      end
    end

    context "画像URLが渡された場合" do
      before do
        stub_for_image_url
        described_class.perform(user.id, image_url)
      end

      it "キャッシュファイルが生成されていること" do
        File.exist?(html_cache_path).should be_true
      end

      it "１つのimgタグを含むこと" do
        html = File.open(html_cache_path).read
        (Hpricot(html)/:img).count.should eq(1)
      end
    end
  end

  private

  def stub_for_page_url
    stub_request(:get, page_url).to_return(body: page_html)
  end

  def stub_for_image_url
    image_file_path = "#{Rails.root}/spec/files/google_logo.png"
    stub_request(:get, image_url).to_return(body: File.read(image_file_path))
  end

  def stub_for_private_pub
    PrivatePub.stub(:publish_to).with('/cliped', /get_image_tags/)
  end

  def page_html
    <<-EOS
      <html>
        <body>
          <img src="#{image_url}" />
        </body>
      </html>
    EOS
  end

  def delete_html_cache_file
    File.delete(html_cache_path) if File.exist?(html_cache_path)
  end
end
