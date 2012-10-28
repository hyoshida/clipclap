# -*- encoding: utf-8 -*-
class TagsController < ApplicationController
  def index
    @tags = Tag.all

    @tag_hash = {}
    @tags.each do |tag|
      @tag_hash[tag.name] ||= 0
      @tag_hash[tag.name] += 1
    end
  end

  def show
    @posts = Post
      .joins(:tags)
      .where('tags.name = ?', params[:name])
      .includes(:image_master, :likes)
      .all
  end
end
