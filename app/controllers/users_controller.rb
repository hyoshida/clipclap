# -*- encoding: utf-8 -*-
class UsersController < ApplicationController
  def show
    @user = User.includes(:clips, :likes, :tags).find(params[:id])
  end
end
