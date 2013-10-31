# -*- encoding: utf-8 -*-
class TagsController < ApplicationController
  def index
    if params[:user_id]
      @user = User.includes(:clips, :likes, :tags).find(params[:user_id])
      @tags = @user.tags.select(&:clip) if @user
    end

    @grouped_tags = (@tags || Tag).group_by(&:name)
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
