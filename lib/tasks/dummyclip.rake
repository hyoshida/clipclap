namespace :dummyclip do
  desc 'Create dummy clips'
  task :create => :environment do
    Clip.delete_all
    create_dummy_clip
  end

  desc 'Add dummy clips'
  task :add => :environment do
    create_dummy_clip
  end

  def create_dummy_clip(count = 1000)
    require Rails.root.join('spec/tasks/clips.rb')
    FactoryGirl.create_list(:dummy_clip, 100)
  end
end
