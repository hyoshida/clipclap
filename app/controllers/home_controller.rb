class HomeController < ApplicationController
  def index
    @posts = Post.paginate(page: params[:page])
    if first_page?
      render
    else
      render text: "<html><body><div id='container'>#{@posts.map {|post| create_image_tag(post) }.join}</div></body></html>"
    end
  end

  private

  def create_image_tag(post)
    <<-EOS
    <ul>
      <li class='box'>
        <img src='#{post.url}' />
        #{post.title.present? ? '<p class="title">' + post.title + '</p>' : ''}
      </li>
    </ul>
    EOS
  end

  def first_page?
    params[:page].blank? || params[:page].to_i <= 1
  end
end
