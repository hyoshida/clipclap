class HomeController < ApplicationController
  before_filter :guest, unless: :user_signed_in?

  def index
    @clips = Clip.paginate(page: params[:page]).includes([ { image: :likes, comments: :user }, :user, :likes, :tags ])
    render action: 'next_page' unless first_page?
  end

  def guest
    @clips = Clip.includes([ { image: :likes, comments: :user }, :user, :likes, :tags ]).reorder('view_count DESC, created_at DESC').paginate(page: params[:page])
    if first_page?
      render action: 'guest', layout: 'application_for_guest'
    else
      render action: 'next_page'
    end
  end
end
