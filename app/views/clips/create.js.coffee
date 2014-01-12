hide_new_clip_dialog = ->
  $new_clip_dialog = $('#new_clip_dialog')
  $new_clip_dialog.modal('hide')

has_alert_flag =->
  <%= !!flash.now[:alert] %>

initialize_alert =->
  $alert = $('#alert')
  if $alert.length == 0
    $alert = $('<div/>').attr('id', 'alert').prependTo('#main .wrap')
  $alert.html('<%= flash.now[:alert] %>')
  <% flash.now[:alert] = nil %>

initialize_notice =->
  $('#notice').remove()
  $('<div/>')
    .attr('id', 'notice')
    .addClass('hidden')
    .appendTo('#header .wrap')
    .html('クリップが投稿されました')
  notify()

reset_form = ->
  $('.chosen-select').trigger("chosen:updated")
  $('#new_clip').get(0).reset();

hide_new_clip_dialog()
if has_alert_flag()
  initialize_alert()
else
  initialize_notice()
reset_form()
