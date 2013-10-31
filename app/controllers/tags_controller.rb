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
    contditions_for_tags = { name: params[:name] }

    if params[:user_id]
      @user = User.includes(:clips, :likes, :tags).find(params[:user_id])
      contditions_for_tags.update(user_id: @user.id) if @user
    end

    @clips ||= Clip.
      joins(:tags).
      where(tags: contditions_for_tags).
      includes(:image_master).
      includes(:likes).
      paginate(page: params[:page]).
      all
  end
end
