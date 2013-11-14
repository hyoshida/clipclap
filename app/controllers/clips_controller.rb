# -*- encoding: utf-8 -*-
class ClipsController < ApplicationController
  before_filter :authenticate_user!, except: [ :index, :show, :get_image_tags ]

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

    doc = Hpricot(load_html_cahce_file)
    @image_tags = (doc/:img).paginate(page: params[:page], per_page: Clip.per_page)
    @html = @image_tags.join
  rescue
    render nothing: true unless @clip
  end

  def get_image_tags_for_next_page
    doc = Hpricot(load_html_cahce_file)
    image_tags = (doc/:img).paginate(page: params[:page], per_page: Clip.per_page)
    html = "<html><body><div id='container'>#{image_tags.map(&insert_div_tag_for_image_tag).join}</div></body></html>"
    render text: html
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
    clip_attr = { user_id: current_user.id }
    @clip = Clip.new(clip_attr.merge(params[:clip]))

    exist_image_flag = Image.where(url: params[:clip][:url]).first.present?

    respond_to do |format|
      if !exist_image_flag && @clip.save
        format.html { redirect_to @clip, notice: 'Clip was successfully created.' }
        format.json { render json: @clip, status: :created, location: @clip }
      else
        flash.now[:alert] = 'This image was existed.' if exist_image_flag
        format.html { render action: :new }
        format.json { render json: @clip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clips/1
  # PUT /clips/1.json
  def update
    @clip = Clip.find(params[:id])

    respond_to do |format|
      if @clip.update_attributes(params[:clip])
        format.html { redirect_to @clip, notice: 'Clip was successfully updated.' }
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

  def authenticate_user!
    return super unless request.xhr?
    return if user_signed_in?
    flash[:alert] = 'この操作にはログインが必要です'
    render js: %{window.location = "#{new_user_session_path}"}
  end

  def insert_div_tag_for_image_tag
    -> image_tag { "<div class='box image_box'>#{image_tag}</div>" }
  end

  def create_html_cahce_file(html)
    FileUtils.mkdir Settings.html_cache_dir unless File.exist? Settings.html_cache_dir
    File.open(html_cache_file_path, 'w') do |file|
      file.write(html)
    end
  end

  def load_html_cahce_file
    File.open(html_cache_file_path).read
  end

  def html_cache_file_path
    File.join(Settings.html_cache_dir, "#{current_user.id}.html")
  end
end
