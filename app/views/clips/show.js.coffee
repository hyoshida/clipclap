$clip_dialog = $('#clip_dialog')
if $clip_dialog.length == 0
  $clip_dialog = $('<div/>')
else
  $clip_dialog.remove()

$clip_dialog.attr('id', 'clip_dialog')
$clip_dialog.html('<%= escape_javascript(render template: 'base/_dialog', formats: :html, locals: { title: 'クリップ詳細' }) %>')
$clip_dialog.find('.modal-body').html('<%= escape_javascript(render template: 'clips/show', formats: :html) %>')
$('#main').append($clip_dialog)
$clip_dialog.find('.modal').modal('show')

$('body').css({ top: -$(window).scrollTop() })
$('body').addClass('noscroll')

$(':focus').blur()

$("[data-toggle='tooltip']").tooltip();
