class HomeController < ApplicationController
  def index
    @clips = Clip.paginate(page: params[:page]).includes([ { image_master: :likes, comments: :user }, :user, :likes, :tags ])
    render action: 'next_page' unless first_page?
  end
end
