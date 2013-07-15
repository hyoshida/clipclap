class HomeController < ApplicationController
  def index
    @clips = Clip.paginate(page: params[:page])
    if first_page?
      render
    else
      render action: 'next_page'
    end
  end
end
