# -*- encoding: utf-8 -*-
class UsersController < ApplicationController
  def show
    @user = User.includes(:clips, :likes, :tags).find(params[:id])
  end

  def follow
    @user = User.where(id: params[:id]).first
    current_user.follow(@user) if @user
  end

  def unfollow
    @user = User.where(id: params[:id]).first
    current_user.stop_follow(@user) if @user
  end
end
