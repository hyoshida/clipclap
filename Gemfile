source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '3.2.14'
gem 'mysql2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :test do
  gem "webmock"
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner'
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem 'factory_girl_rails'
  gem 'coveralls', require: false
end

group :development do
  # Deploy with Capistrano
  gem 'capistrano'
  gem 'capistrano-rbenv'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'

  gem 'font-awesome-sass-rails'

  # ブロック整列, image loaded, infinitescroll
  gem 'masonry-rails'

  # to use Twitter-Boostrap
  gem 'therubyracer'
  gem 'bootstrap-sass', '~> 2.3.1.0'
  gem 'bootstrap-modal-rails'

  gem 'compass-rails'
  gem 'compass-colors'
  gem 'zurui-sass-rails'

  # デプロイの高速化 (Rails4では不要)
  gem 'turbo-sprockets-rails3'
end

# 最新版(jQuery 1.9)だとinfinitescrollが動作しないため2.1.x系(jQuery 1.8)を指定
gem 'jquery-rails', '~> 2.1.4'
gem 'jquery-ui-rails'

# Support CoffeeScript
gem 'coffee-rails'
gem 'uglifier'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
gem 'unicorn'
gem 'unicorn-rails'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# To use user authentication
gem 'devise'
gem 'devise-i18n'

# HTMLをRubyで簡単に扱えるようにする
gem 'hpricot'

# 画像サイズの取得に利用
gem 'image_size'

# アプリケーションの設定を保存
gem 'settingslogic'

# ページングに利用(TODO: kaminariに切り替え)
gem 'will_paginate', '~> 3.0.3'
gem 'kaminari'

# DBデータのインポート/エクスポート
gem 'yaml_db'

# ローカライズ
gem 'i18n_generators'

# 管理画面(YAMLまわりでワーニングが出るので最新版を取得)
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'

# to use Rails 4 like arel
gem 'everywhere'

# Facebookでログイン
gem 'omniauth-facebook'
# Twitterでログイン
gem 'omniauth-twitter'

# RailsのViewにSlimを利用
gem "slim-rails"

# フォロー/フォロワー機能を追加
gem 'acts_as_follower', '~> 0.1.1'

# 補足出来なかった例外をメール送信
gem 'exception_notification'

# 非同期処理
gem 'resque'

# リアルタイムメッセージング
gem 'private_pub'
gem 'thin'
gem 'addressable'

# アプリケーション管理
gem 'foreman'
gem 'bluepill'

# リソース監視
gem 'newrelic_rpm'

# アクセス解析
gem 'google-analytics-rails'

# open-uriにリダイレクト用のオプションを追加
gem 'open_uri_redirections'

# 画像リサイズ用
gem 'mini_magick'

# タグ追加時の選択フォーム
gem 'chosen-rails'
