# -*- encoding: utf-8 -*-
class ClipsController < ApplicationController
  before_filter :authenticate_user!, except: [ :index, :get_image_tags ]
  skip_before_filter :authenticate_user!, if: :show_for_not_xhr?

  require 'will_paginate/array'

  def clipping
    return unless params[:clip]
    return unless params[:clip][:origin_url]
    Resque.enqueue(ImageClipper, current_user.id, params[:clip][:origin_url])
  ensure
    render nothing: true
  end

  # for Ajax
  def get_image_tags
    return get_image_tags_for_next_page if params[:page].to_i.nonzero?

    return unless params[:clip]
    return unless params[:clip][:origin_url]
    @clip = Clip.new(params[:clip])
    return unless @clip

    @image_tags = image_tags_from_html
    @image_tags = image_tag(@clip.url) if @image_tags.blank?
  rescue
    logger.error $!.message + $!.backtrace.join("\n")
    render nothing: true unless @clip
  end

  def like
    @clip = Clip.where(id: params[:id]).first
    current_user.like(@clip) unless @clip.nil?
  end

  def unlike
    @clip = Clip.where(id: params[:id]).first
    current_user.unlike(@clip) unless @clip.nil?
  end

  def tagging
    clip = Clip.where(id: params[:id]).first
    return if clip.tags_maximum?
    attributes = {
      name: params[:tag][:name].strip,
      user_id: current_user.id
    }
    @tag = clip.tags.create(attributes)
  end

  def untagging
    @tag = Tag.where(id: params[:tag_id]).first
    @tag.destroy
  end

  def comment
    @comment = Clip.where(id: params[:id]).first.comments.create(
      user_id: current_user.id,
      body: params[:comment][:body].strip
    )
  end

  def uncomment
    @comment = Comment.where(id: params[:comment_id]).first
    @comment.destroy
  end

  def reclip
    parent_clip = Clip.where(id: params[:id]).first
    return unless parent_clip
    @clip = current_user.reclip(parent_clip)
  end

  def unreclip
    @clip = Clip.where(parent_id: params[:id], user_id: current_user.id).first
    return unless @clip
    @clip.destroy
  end

  # GET /clips.json
  def index
    if params[:user_id]
      @user = User.includes(:clips, :likes, :tags).find(params[:user_id])
      @clips = @user.clips if @user
    end

    @clips = (@clips || Clip).paginate(page: params[:page])
    render 'home/next_page' unless first_page?
  end

  # GET /clips/1
  # GET /clips/1.js
  def show
    @clip = Clip.includes(:user, :image, :tags).find(params[:id])
    @clip.increment_view_count!(request)

    respond_to do |format|
      format.html # show.html.erb
      format.js # show.js.coffee
    end
  end

  # GET /clips/new
  # GET /clips/new.json
  def new
    @clip = Clip.new
    @url = params[:url] if params[:url]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @clip }
    end
  end

  # GET /clips/1/edit
  def edit
    @clip = Clip.find(params[:id])
  end

  # POST /clips
  # POST /clips.json
  def create
    tag_names = tag_names_by_params(:clip)
    clip_attr = { user_id: current_user.id }
    @clip = Clip.new(clip_attr.merge(params[:clip]))

    exist_image_flag = Image.where(url: params[:clip][:url]).first.present?

    respond_to do |format|
      if !exist_image_flag && @clip.save
        update_tags_for(@clip, tag_names)

        format.html { redirect_to @clip, notice: 'クリップを投稿しました' }
        format.json { render json: @clip, status: :created, location: @clip }
        format.js { render }
      else
        flash.now[:alert] = 'すでに存在している画像です' if exist_image_flag
        format.html { render action: :new }
        format.json { render json: @clip.errors, status: :unprocessable_entity }
        format.js { render }
      end
    end
  end

  # PUT /clips/1
  # PUT /clips/1.json
  def update
    @clip = Clip.find(params[:id])

    respond_to do |format|
      if @clip.update_attributes(params[:clip])
        format.html { redirect_to @clip, notice: 'クリップを更新しました' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @clip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clips/1
  # DELETE /clips/1.json
  def destroy
    @clip = Clip.find(params[:id])
    @clip.destroy

    respond_to do |format|
      format.html { redirect_to clips_url }
      format.json { head :no_content }
    end
  end

  private

  def get_image_tags_for_next_page
    render partial: 'wall', locals: { image_tags: image_tags_from_html }
  end

  def image_tags_from_html
    doc = Hpricot(load_html_cahce_file)
    image_tags = (doc/:img).paginate(page: params[:page], per_page: Clip.per_page)
  end

  def load_html_cahce_file
    File.open(html_cache_file_path).read
  end

  def html_cache_file_path
    File.join(Settings.html_cache_dir, "#{current_user.id}.html")
  end

  def show_for_not_xhr?
    # skip_before_filterではonlyとifを併用できないバグあり
    # https://github.com/rails/rails/issues/9703
    params[:action].to_sym == :show && !request.xhr?
  end
end
