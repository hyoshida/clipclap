# -*- encoding: utf-8 -*-
class UsersController < ApplicationController
  before_filter :current_user_own_action!, only: [ :edit, :update, :destroy ]

  def show
    @user = User.includes(:clips, :likes, :tags).find(params[:id])
  end

  # GET /clips/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # PUT /clips/1
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'プロフィールを更新しました'
    else
      render action: :edit
    end
  end

  def follow
    @user = User.where(id: params[:id]).first
    current_user.follow(@user) if @user
  end

  def unfollow
    @user = User.where(id: params[:id]).first
    current_user.stop_following(@user) if @user
  end

  private

  def current_user_own_action!
    return if signed_in? && current_user.id == params[:id].to_i
    redirect_to user_path(params[:id])
  end
end
