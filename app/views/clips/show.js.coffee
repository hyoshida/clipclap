$clip_detail_pane = $('#clip_detail_pane')
if $clip_detail_pane.length == 0
  $clip_detail_pane = $('<div/>')
else
  $clip_detail_pane.remove()

$clip_detail_pane.attr('id', 'clip_detail_pane')
$clip_detail_pane.css('display', 'none')
$clip_detail_pane.html('<%= escape_javascript(render template: 'clips/show', id: @clip, formats: :html) %>')
$('#mainContainer').append($clip_detail_pane)

$slide_overlay = $('<div/>')
$slide_overlay.attr('id', 'slide_overlay')
$slide_overlay.attr('class', 'ui-widget-overlay')
$slide_overlay.css({ display: 'none', width: '100%', height: '100%' })
$('#mainContainer').append($slide_overlay)

$clip_detail_pane.show("slide", { direction: "right" })
$slide_overlay.show("fade")

$('body').addClass('noscroll')

$(':focus').blur()

$("[data-toggle='tooltip']").tooltip();
