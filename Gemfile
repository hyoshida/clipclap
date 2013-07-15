source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development do
  gem 'sqlite3'
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem 'factory_girl_rails'
end

group :production do
  gem 'mysql2'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
  gem 'font-awesome-sass-rails'
end

# 最新版(jQuery 1.9)だとinfinitescrollが動作しないため2.1.x系(jQuery 1.8)を指定
gem 'jquery-rails', '~> 2.1.4'
gem 'jquery-ui-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# To use user authentication
gem 'devise'

# HTMLをRubyで簡単に扱えるようにする
gem 'hpricot'

# 画像サイズの取得に利用
gem 'image_size'

# アプリケーションの設定を保存
gem 'settingslogic'

# ページングに利用(TODO: kaminariに切り替え)
gem 'will_paginate', '~> 3.0.3'

# DBデータのインポート/エクスポート
gem 'yaml_db'

# ローカライズ
gem 'i18n_generators'

# 管理画面(YAMLまわりでワーニングが出るので最新版を取得)
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'

# ブロック整列, image loaded, infinitescroll
gem 'masonry-rails'

# to use Rails 4 like arel
gem 'everywhere'

# to use Twitter-Boostrap
gem 'therubyracer'
gem 'less-rails'
gem 'twitter-bootstrap-rails'


