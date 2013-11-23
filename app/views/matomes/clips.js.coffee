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

# <div />で囲まないと、body 直下の img が取得できない
html = '<div><%= raw @clips.map {|clip| image_tag(clip.url, 'data-clip-id' => clip.id) }.join %></div>'

$(html).find('img').each( ->
  box = $('<div id="active_box" class="box image_box" />')
  box.appendTo('#container')
  $(@).appendTo('#active_box')
  box.removeAttr('id')
)

$container.css({ opacity: 0 }).imagesLoaded( ->
  resize_images()
  @.removeClass('hidden')
  @.masonry('reload')
  @.find('img:first').attr('id', 'selected')
  @.animate({ opacity: 1 })

  # 無限スクロール機能の初期化
  initialize_infinitescroll()

  $container.infinitescroll('retrieve') unless can_scroll()
)
