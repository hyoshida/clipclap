namespace :dummypost do
  desc 'Create dummy posts'
  task :create => :environment do
    Post.delete_all
    create_dummy_post
  end

  desc 'Add dummy posts'
  task :add => :environment do
    create_dummy_post
  end

  def create_dummy_post(count = 1000)
    require Rails.root.join('spec/tasks/posts.rb')
    FactoryGirl.create_list(:dummy_post, 100)
  end
end
