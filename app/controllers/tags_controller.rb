# -*- encoding: utf-8 -*-
class TagsController < ApplicationController
  def index
    if params[:user_id]
      @user = User.includes(:clips, :likes, :tags).find(params[:user_id])
      @tags = @user.tags if @user
    end

    @tags = (@tags || Tag).all
    @tag_hash = {}
    @tags.each do |tag|
      @tag_hash[tag.name] ||= 0
      @tag_hash[tag.name] += 1
    end
  end

  def show
    @clips = Clip
      .joins(:tags)
      .where('tags.name = ?', params[:name])
      .includes(:image_master, :likes)
      .paginate(page: params[:page])
      .all
  end
end
