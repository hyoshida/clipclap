class HomeController < ApplicationController
  def index
    @clips = Clip.paginate(page: params[:page]).includes([ { image: :likes, comments: :user }, :user, :likes, :tags ])
    render action: 'next_page' unless first_page?
  end
end
