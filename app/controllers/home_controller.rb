class HomeController < ApplicationController
  def index
    @clips = Clip.paginate(page: params[:page]).includes([ { image: :likes, comments: :user }, :user, :likes, :tags ])
    @hot_tags = Tag.newest(50).shuffle
    @new_matomes = Matome.limit(5).all
    render action: 'next_page' unless first_page?
  end
end
