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
#= require jquery.ui.dialog
#= require jquery.ui.effect-slide
#= require jquery.ui.effect-fade
#= require jquery_ujs
#= require bootstrap
#= require bootstrap-tooltip
#= require bootstrap-popover
#= require bootstrap-transition
#= require masonry/jquery.masonry
#= require masonry/jquery.imagesloaded.min
#= require masonry/jquery.infinitescroll.min

$( ->
  register_event_for_open_siginup_dialog()
  register_event_for_close_siginup_dialog()
  $("[data-toggle='tooltip']").tooltip()
)

register_event_for_close_siginup_dialog =->
  $(document).on('click', '#slide_overlay', ->
    $('#siginup_dialog').hide('fade', null, 400, -> $(@).remove())
    $('#slide_overlay').hide('fade', null, 400, -> $(@).remove())
  )

register_event_for_open_siginup_dialog =->
  $('#container').on('click', 'a', (event) ->
    # デフォルトの挙動をキャンセル
    event.stopPropagation()
    event.preventDefault()

    $siginup_dialog = $('#siginup_dialog')
    if $siginup_dialog.length == 0
      $siginup_dialog = $('<div/>')
    else
      $siginup_dialog.remove()

    $siginup_dialog_form = $('<div/>')
    $siginup_dialog_form.attr('class', 'form')
    $siginup_dialog_form.html($('#header .form').html())

    $siginup_dialog.attr('id', 'siginup_dialog')
    $siginup_dialog.css('display', 'none')
    $siginup_dialog.html($siginup_dialog_form)
    $('#main').append($siginup_dialog)

    $slide_overlay = $('<div/>')
    $slide_overlay.attr('id', 'slide_overlay')
    $slide_overlay.attr('class', 'ui-widget-overlay')
    $slide_overlay.css({ display: 'none', width: '100%', height: '100%' })
    $('#main').append($slide_overlay)

    $siginup_dialog.show('fade')
    $slide_overlay.show('fade')

    $(':focus').blur()
  )
