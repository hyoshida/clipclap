class ImageClipper
  @queue = :image_clippers_queue

  require 'hpricot'

  class << self
    def perform(user_id, target_url)
      @user_id = user_id
      @target_url = target_url
      download_html
      publish
    end

    private

    def publish
      PrivatePub.publish_to('/cliped', "$.get('/clips/get_image_tags', #{params_for_publish.to_json});")
    end

    def params_for_publish
      {
        clip: {
          origin_url: @target_url
        }
      }
    end

    def publish_for_error(message)
      PrivatePub.publish_to('/cliped', "$('#container').text('#{message}');")
    end

    def download_html
      clip = Clip.new(origin_url: @target_url)
      clip.fill_origin_entry
      html = clip.create_html_only_images
      create_html_cahce_file(html)
    rescue
      publish_for_error($!.message)
      raise
    end

    def create_html_cahce_file(html)
      FileUtils.mkdir(Settings.html_cache_dir) unless File.exist? Settings.html_cache_dir
      File.open(html_cache_file_path, 'w') do |file|
        file.write(html)
      end
    end

    def html_cache_file_path
      File.join(Settings.html_cache_dir, "#{@user_id}.html")
    end
  end
end
