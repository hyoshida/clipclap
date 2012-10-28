# -*- encoding: utf-8 -*-
class PostsController < ApplicationController
  before_filter :logged_in?, except: [ :index, :show, :get_image_tags, :like ]

  # for Ajax
  def get_image_tags
    require 'will_paginate/array'
    require 'hpricot'
    html = ''
    if params[:page].blank? || params[:page].to_i <= 1
      @post = Post.new(params[:post])
      @post.fill_origin_entry
      html = @post.create_html_only_images
      create_html_cahce_file(html)
    else
      html = load_html_cahce_file
    end
    doc = Hpricot(html)
    @page = (doc/:img).paginate(page: params[:page], per_page: Post.per_page)
    if params[:page].blank? || params[:page].to_i <= 1
      @html = @page.join
      render
    else
      @html = "<html><body><div id='container'>#{@page.map(&insert_div_tag_for_image_tag).join}</div></body></html>"
      render text: @html
    end
  end

  def like
    @post = Post.where(id: params[:id]).first
    current_user.like(@post) unless @post.nil?
  end

  def unlike
    @post = Post.where(id: params[:id]).first
    current_user.unlike(@post) unless @post.nil?
  end

  def tagging
    post = Post.where(id: params[:id]).first
    return if post.tags_maximum?
    attributes = {
      name: params[:tag][:name].strip,
      user_id: current_user.id
    }
    @tag = post.tags.create(attributes)
  end

  def untagging
    @tag = Tag.where(id: params[:tag_id]).first
    @tag.destroy
  end


  # GET /posts.json
  def index
    @posts = Post.includes(:user).includes(:image_master).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.includes(:user).includes(:image_master).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
 def create
    post_attr = { user_id: current_user.id }
    @post = Post.new(post_attr.merge(params[:post]))

    exist_image_flag = ImageMaster.where(url: params[:post][:url]).first.present?

    respond_to do |format|
      if !exist_image_flag && @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        flash.now[:alert] = 'This image was existed.' if exist_image_flag
        format.html { render action: :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private

  def owner_user_operation?
    return if user_signed_in?
    flash.now[:alert] = 'この操作を実施する権限がありません'
    redirect_to posts_url
  end

  def logged_in?
    return if user_signed_in?
    flash.now[:alert] = 'この操作にはログインが必要です'
    redirect_to posts_url
  end

  def insert_div_tag_for_image_tag
    -> image_tag { "<div class='box'>#{image_tag}</div>" }
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
    File.join(Settings.html_cache_dir, "#{current_user.id.to_s}.html")
  end
end
