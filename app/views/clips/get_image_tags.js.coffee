is_available_image_size = (width, height) ->
  aspect = width / height * 1.0
  width > <%= Settings.minimum_image_width %> &&
    height > <%= Settings.minimum_image_height %> &&
    aspect < <%= Settings.allowed_image_aspect[0] / Settings.allowed_image_aspect[1] * 1.0 %> &&
    aspect > <%= Settings.allowed_image_aspect[1] / Settings.allowed_image_aspect[0] * 1.0 %>

resize_images = ->
  $('#container').find('.box img').each( ->
    width = <%= Settings.thumb_width %>
    height = Math.floor($(@).height() * (width / $(@).width() * 1.0))
    if is_available_image_size(width, height)
      $(@).width(width)
      $(@).height(height)
    else
      $(@).parent().remove()
  )

infinitescroll_options = ->
  {
    navSelector: '#page-nav',
    nextSelector: '#page-nav a',
    itemSelector: '.box',
    loading: {
      finishedMsg: 'image was finished.',
      img: '<%= asset_path 'loader.gif' %>'
    },
    state: {
      isDestroyed: false,
      isDone: false
    }
  }

destroy_infinitescroll = ->
  $container = $('#container')
  $container.infinitescroll('destroy')
  $container.data('infinitescroll', null)

initialize_infinitescroll = ->
  $container = $('#container')
  $container.infinitescroll(infinitescroll_options(), (newElements) ->
    $(newElements).css({ opacity: 0 }).imagesLoaded( ->
      resize_images()
      $container.masonry('appended', @, true)
      @.animate({ opacity: 1 })
    )
  )
  $container.infinitescroll('bind')

$container = $('#container')

# 古い無限スクロールのメタデータを破棄
destroy_infinitescroll()

$container.html('&nbsp;')
$container.attr('style', 'position: relative;')

page_nav = $('<div/>')
page_nav.attr('id', 'page-nav')
page_nav.html('<%= link_to 'next', page: @image_tags.next_page %>')
page_nav.insertAfter('#container')

# <div />で囲まないと、body 直下の img が取得できない
html = '<div><%= raw @html.gsub("'", '"').presence || (@clip.url && image_tag(@clip.url)) || '' %></div>'

$(html).find('img').each( ->
  box = $('<div id="active_box" class="box" />')
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

$container.on('click', '.box img', ->
  $('img#selected').removeAttr('id')
  $(@).attr('id', 'selected')

  url = $(@).attr('src')
  $('#clip_url').attr('value', url)

  link = $('<a/>')
  link.attr('src', url)
  link.attr('id', 'link')
  link.insertBefore('img#selected')

  $(@).appedTo('#link')
  link.removeAttr('id')
)

$('#clip_origin_url').attr('value', '<%= @clip.origin_url %>')
