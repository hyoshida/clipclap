$clip_dialog = $('#clip_dialog')
if $clip_dialog.length == 0
  $clip_dialog = $('<div/>')
else
  return if $clip_dialog.is(':visible')
  $clip_dialog.removeAttr('id')
  $clip_dialog.remove()

$clip_dialog.html('<%= escape_javascript(render template: 'base/_dialog', formats: :html, locals: { id: :clip_dialog, title: 'クリップ詳細' }) %>')
$clip_dialog.find('.modal-body').html('<%= escape_javascript(render template: 'clips/show', formats: :html) %>')
$clip_dialog.appendTo('body')
$clip_dialog.find('.modal').modal('show')

$(':focus').blur()

$("[data-toggle='tooltip']").tooltip();
