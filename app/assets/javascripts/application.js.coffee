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
#= require bootstrap-dropdown
#= require bootstrap-carousel
#= require bootstrap-transition
#= require bootstrap-modal
#= require masonry/jquery.masonry
#= require masonry/jquery.imagesloaded.min
#= require masonry/jquery.infinitescroll.min
#= require private_pub

$( ->
  $("[data-toggle='tooltip']").tooltip()
  register_event_for_close_dialog()

  notify()
)

register_event_for_close_dialog =->
  $(document).on('click', '.ui-widget-overlay', ->
    $('.ui-dialog-content').dialog('close')
  )

notify = ->
  return if $('#notice').length <= 0
  height =  $('#notice').css('height')
  $('#notice')
    .css({ height: 0 })
    .delay(400)
    .animate({ height: height })
    .delay(5 * 1000)
    .animate({ height: 0 })
