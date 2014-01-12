# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require jquery.ui.dialog
#= require jquery.ui.effect-slide
#= require jquery.ui.effect-fade
#= require bootstrap
#= require bootstrap-tooltip
#= require bootstrap-popover
#= require bootstrap-dropdown
#= require bootstrap-carousel
#= require bootstrap-transition
#= require bootstrap-modal
#= require bootstrap-modalmanager
#= require masonry/jquery.masonry
#= require masonry/jquery.imagesloaded.min
#= require masonry/jquery.infinitescroll.min
#= require private_pub
#= require chosen-jquery

$( ->
  register_event_for_close_dialog()
  notify()
  initialize_chosen()
)

register_event_for_close_dialog =->
  $(document).on('click', '.ui-widget-overlay', ->
    $('.ui-dialog-content').dialog('close')
  )

notify = ->
  return if $('#notice').length <= 0
  height =  $('#notice').css('height')
  $('#notice')
    .removeClass('hidden')
    .css({ height: 0 })
    .delay(400)
    .animate({ height: height })
    .delay(5 * 1000)
    .animate({ height: 0 })

initialize_chosen = ->
  $chosen_select = $('.chosen-select')
  $chosen_select.chosen(no_results_text: 'エンターキーで次のタグを追加: ')
  $('.chosen-container-multi').on('keyup', 'input[type="text"]', (event) ->
    # Enterキーでない場合は何もしない
    VK_ENTER = 13
    keycode = event.keyCode || event.which
    return unless keycode == VK_ENTER

    # マッチする結果がある場合は何もしない
    chosen = $chosen_select.data('chosen')
    return unless chosen
    return if chosen.result_highlight

    # すでに存在する項目であれば何もしない
    old_values = []
    $chosen_select.find('option').each( ->
      old_values.push($(@).val().toLowerCase())
    )
    new_value = $(@).val()
    return if $.inArray(new_value.toLowerCase(), old_values) != -1

    # あたらしい項目を追加する
    event.preventDefault()

    selected_values = $chosen_select.val() || []
    selected_values.push(new_value)

    $chosen_select.append("<option value='" + new_value + "'>" + new_value + "</option>")
    $chosen_select.val(selected_values)
    $chosen_select.trigger("chosen:updated")
  )
