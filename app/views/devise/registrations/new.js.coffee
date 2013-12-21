$dialog = $('#dialog')
if $dialog.length == 0
  $dialog = $('<div/>')
else
  $dialog.remove()

$dialog.attr('id', 'dialog')
$dialog.html('<%= escape_javascript(render template: 'base/_dialog', formats: :html, locals: { title: 'ログインするとお得な機能がいっぱい！', show: true }) %>')
$dialog.find('.modal-body').html('<%= escape_javascript(render template: 'devise/registrations/new', formats: :html) %>')
$('#container').append($dialog)

$dialog.find('.modal').modal('show')
