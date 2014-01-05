# -*- encoding: utf-8 -*-
class TagsController < ApplicationController
  def index
    if params[:user_id]
      @user = User.includes(:clips, :likes, :tags).find(params[:user_id])
      @tags = @user.tags if @user
    end

    @grouped_tags = (@tags || Tag.all).group_by(&:name)
  end

  def show
    contditions_for_tags = { name: params[:name] }
    contditions_for_tags.update(tagged_type: params[:type].classify) if params[:type].present?

    if params[:user_id]
      @user = User.includes(:clips, :likes, :tags).find(params[:user_id])
      contditions_for_tags.update(user_id: @user.id) if @user
    end

    @taggeds = Tag.
      where(contditions_for_tags).
      paginate(page: params[:page]).
      map(&:tagged)
  end
end
