# 古い無限スクロールのメタデータを破棄
destroy_infinitescroll()

$container = $('#container')
$container.html('&nbsp;')
$container.attr('style', 'position: relative;')

# 次のページが存在する場合のみinfinitescroll用のリンクを追加
<% if @image_tags.next_page %>
page_nav = $('<div/>')
page_nav.attr('id', 'page-nav')
page_nav.html('<%= link_to 'next', page: @image_tags.next_page %>')
page_nav.insertAfter('#container')
<% end %>

$container.html("<%= escape_javascript(render template: 'clips/_wall', formats: :html, locals: { image_tags: @image_tags }) %>")

$container.css({ opacity: 0 }).imagesLoaded( ->
  resize_images()
  @.removeClass('hidden')
  @.masonry('reload')
  @.animate({ opacity: 1 })

  # 無限スクロール機能の初期化
  initialize_infinitescroll()

  $container.infinitescroll('retrieve') unless can_scroll()
)

$('#clip_origin_url').attr('value', '<%= @clip.origin_url %>')
