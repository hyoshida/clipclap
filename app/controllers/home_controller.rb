class HomeController < ApplicationController
  def index
    @posts = Post.paginate(page: params[:page])
    if first_page?
      render
    else
      render action: 'next_page'
    end
  end

  private

  def first_page?
    params[:page].blank? || params[:page].to_i <= 1
  end
end
