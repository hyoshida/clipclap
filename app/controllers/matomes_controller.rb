class MatomesController < ApplicationController
  # GET /matomes
  def index
    if params[:user_id]
      @user = User.includes(:clips, :likes, :tags).find(params[:user_id])
      @matomes = @user.matomes if @user
    end
    @matomes ||= Matome.all
  end

  # GET /matomes/:id
  def show
    @matome = Matome.find(params[:id])
    @clips = @matome.clips
    @cover_clip = @clips.try(:first)
  end

  # GET /matomes/new
  def new
    @matome = Matome.new
  end

  # XHR GET /matomes/clips
  def clips
    @clips = Clip.where(user_id: current_user.id).paginate(page: params[:page])
    render text: "<html><body><div id='container'>#{@clips.map(&insert_div_tag_for_image_tag).join}</div></body></html>" unless first_page?
  end

  # POST /clips
  def create
    clip_ids = params[:matome].delete(:clip_ids)
    @matome = Matome.new(params[:matome])

    @matome.user = current_user
    @matome.clips = Clip.where(user_id: current_user.id, id: clip_ids)

    if @matome.save
      redirect_to @matome, notice: "「#{@matome.title}」まとめを作成しました"
    else
      flash[:alert] = @matome.errors.full_messages.join
      render action: :new
    end
  end

  # GET /matomes/:id/edit
  def edit
    @matome = Matome.find(params[:id])
    @clips = @matome.clips
    @cover_clip = @clips.try(:first)
  end

  private

  def insert_div_tag_for_image_tag
    -> clip { "<div class='box image_box'><img src='#{clip.url}' data-clip-id='#{clip.id}' /></div>" }
  end
end
