# -*- encoding: utf-8 -*-
class RankingController < ApplicationController
  def views
    @posts = target_posts_to_ranking_views
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def likes
    @posts = target_posts_to_ranking_likes
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  private

  def target_posts_to_ranking_views
    Post
      .includes(:user, :image_master, :likes, :tags)
      .order(:view_count)
      .limit(Settings.ranking_limit)
      .all
  end

  def target_posts_to_ranking_likes
    Post
      .includes(:user, :image_master, :tags)
      .joins(:likes)
      .sort_by {|post| [ -post.like_count, -post.created_at.to_i ] }
      .uniq
      .slice(0..Settings.ranking_limit)
  end
end
