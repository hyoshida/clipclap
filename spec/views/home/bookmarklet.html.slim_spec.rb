require 'spec_helper'

describe "home/bookmarklet.html.slim" do
  before { render }

  it "正常にページが表示できること" do
    expect(rendered).to match /ブックマークレット/
  end
end
