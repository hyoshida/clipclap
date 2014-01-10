$dialog = $('#dialog')
if $dialog.length == 0
  $dialog = $('<div/>')
else
  return if $dialog.is(':visible')
  $dialog.removeAttr('id')
  $dialog.remove()

$dialog.html('<%= escape_javascript(render template: 'base/_dialog', formats: :html, locals: { id: :dialog, title: 'ログインするとお得な機能がいっぱい！' }) %>')
$dialog.find('.modal-body').html('<%= escape_javascript(render template: 'devise/registrations/new', formats: :html) %>')
$dialog.appendTo('body')
$dialog.find('.modal').modal('show')
