# -*- encoding: utf-8 -*-
class PostsController < ApplicationController
  before_filter :logged_in?, except: [ :index, :show ]

  # for Ajax
  def get_image_tags
    @post = Post.new(params[:post])
    @post.fill_origin_entry
    @html = @post.origin_html
    render
  end

  # GET /posts.json
  def index
    @posts = Post.includes(:user).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.includes(:user).find(params[:id])

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

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
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
    flash.now[:notice] = 'この操作を実施する権限がありません'
    redirect_to posts_url
  end

  def logged_in?
    return if user_signed_in?
    flash.now[:notice] = 'この操作にはログインが必要です'
    redirect_to posts_url
  end
end
