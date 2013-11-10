# 古い無限スクロールのメタデータを破棄
destroy_infinitescroll()

$container = $('#container')
$container.html('&nbsp;')
$container.attr('style', 'position: relative;')

page_nav = $('<div/>')
page_nav.attr('id', 'page-nav')
page_nav.html('<%= link_to 'next', page: @image_tags.next_page %>')
page_nav.insertAfter('#container')

# <div />で囲まないと、body 直下の img が取得できない
html = '<div><%= raw @html.gsub("'", '"').presence || (@clip.url && image_tag(@clip.url)) || '' %></div>'

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
)

$('#clip_origin_url').attr('value', '<%= @clip.origin_url %>')
