require 'spec_helper'

describe "matomes/new.html.slim" do
  let (:matome) { Matome.new }

  before { assign(:matome, matome) }
  before { render }

  subject { response }

  it { should render_template(partial: '_form') }
  it { should have_field(:matome_title, type: 'text') }
  it { should have_field(:matome_description, type: 'textarea') }

  it "クリップが表示されていないこと" do
    should_not have_css('img')
  end
end
