class ImageClipper
  @queue = :image_clippers_queue

  require 'hpricot'

  class << self
    def perform(target_url)
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

    def download_html
      clip = Clip.new(origin_url: @target_url)
      clip.fill_origin_entry
      html = clip.create_html_only_images
      create_html_cahce_file(html)
    end

    def create_html_cahce_file(html)
      FileUtils.mkdir(Settings.html_cache_dir) unless File.exist? Settings.html_cache_dir
      File.open(html_cache_file_path, 'w') do |file|
        file.write(html)
      end
    end

    def html_cache_file_path
      File.join(Settings.html_cache_dir, "#{hash_by_target_url}.html")
    end

    def hash_by_target_url
      require 'digest/sha2'
      Digest::SHA256.hexdigest(@target_url)
    end
  end
end
