hide_new_clip_dialog = ->
  $new_clip_dialog = $('#new_clip_dialog')
  $new_clip_dialog.modal('hide')

has_alert_flag = ->
  <%= !!flash.now[:alert] %>

initialize_notice = (text) ->
  $('#alert').remove()
  $('#notice').remove()
  $('<div/>')
    .attr('id', 'notice')
    .addClass('hidden')
    .appendTo('#header .wrap')
    .text(text)
  notify()

reset_form = ->
  $('.chosen-select').trigger("chosen:updated")
  $('#new_clip').get(0).reset();

hide_new_clip_dialog()
if has_alert_flag()
  initialize_notice('エラー: <%= flash.now[:alert] %>')
  <% flash.now[:alert] = nil %>
else
  initialize_notice('クリップが投稿されました')
reset_form()
