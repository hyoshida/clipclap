class MatomesController < ApplicationController
  before_filter :authenticate_user!, except: [ :index, :show ]

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
    @matome.increment_view_count!(request)
    @clips = @matome.clips.page(params[:page])
    @cover_clip = @clips.try(:first)

    # 関連まとめ
    @related_matomes = {}
    # 1. 同じキュレータ
    @related_matomes[:user] = @matome.related_by_user.limit(5)
    # 2. 同じクリップを含む
    @related_matomes[:clip] = @matome.related_by_clips.limit(5)
    # 3. 同じタグを含む
    # TODO: SQLの最適化
    @related_matomes[:tag] = @matome.related_by_tags.take(5)

    return if first_page?

    if user_signed_in?
      render 'home/next_page', layout: false
    else
      render nothing: true
    end
  end

  # GET /matomes/new
  def new
    @matome = Matome.new
    @clips = @matome.clips
  end

  # XHR GET /matomes/clips
  def clips
    clip_ids = params[:matome][:clip_ids] if params[:matome]
    @clips = Clip.where(user_id: current_user.id).where.not(id: clip_ids).paginate(page: params[:page])
    render template: "matomes/_wall" unless first_page?
  end

  # POST /clips
  def create
    tag_names = tag_names_by_params(:matome)
    clip_ids = params[:matome].delete(:clip_ids)
    @matome = Matome.new(params[:matome])

    @matome.user = current_user
    @matome.clips = Clip.where(user_id: current_user.id, id: clip_ids)

    if @matome.save
      update_tags_for(@matome, tag_names)
      redirect_to @matome, notice: "「#{@matome.title}」まとめを作成しました"
    else
      @clips = @matome.clips
      render action: :new
    end
  end

  # GET /matomes/:id/edit
  def edit
    @matome = Matome.find(params[:id])
    @clips = @matome.clips
    @cover_clip = @clips.try(:first)
  end

  # PUT /clips/:id
  def update
    tag_names = tag_names_by_params(:matome)
    clip_ids = params[:matome].delete(:clip_ids)

    @matome = Matome.find(params[:id])
    @matome.clip_ids = Clip.where(user_id: current_user.id, id: clip_ids).pluck(:id)

    if @matome.force_update_attributes(params[:matome])
      update_tags_for(@matome, tag_names)
      redirect_to @matome, notice: "「#{@matome.title}」まとめを更新しました"
    else
      @clips = @matome.clips
      render action: :edit
    end
  end

  # XHR POST /matomes/:id/like
  def like
    @matome = Matome.where(id: params[:id]).first
    current_user.like(@matome) if @matome
    render action: :like
  end

  # XHR DELETE /matomes/:id/like
  def unlike
    @matome = Matome.where(id: params[:id]).first
    current_user.unlike(@matome) if @matome
    render action: :unlike
  end

  private

  def insert_div_tag_for_image_tag
    -> clip { "<div class='box image_box'><img src='#{clip.url}' data-clip-id='#{clip.id}' /></div>" }
  end
end
