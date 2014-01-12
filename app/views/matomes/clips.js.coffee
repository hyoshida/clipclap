# 古い無限スクロールのメタデータを破棄
destroy_infinitescroll()

# 複数ロードできないようにボタンを削除
$('#load').remove()

$container = $('#container')
$container.html('&nbsp;')
$container.attr('style', 'position: relative;')

page_nav = $('<div/>')
page_nav.attr('id', 'page-nav')
page_nav.html('<%= link_to 'next', page: @clips.next_page %>')
page_nav.insertAfter('#container')

$container.html("<%= escape_javascript(render template: 'matomes/_wall', formats: :html) %>")

$container.css({ opacity: 0 }).imagesLoaded( ->
  resize_images()
  @.removeClass('hidden')
  @.masonry('reload')
  @.animate({ opacity: 1 })

  # 無限スクロール機能の初期化
  initialize_infinitescroll()

  $container.infinitescroll('retrieve') unless can_scroll()
)
