<% if @comment.nil? %>
<% elsif @comment.errors.present? %>
  errors = $('<ul/>')
  <% @tag.errors.full_messages.each do |message| %>
    error = $('<li/>')
    error.html('<%= message %>')
    errors.append(error)
  <% end %>
  $('.alert').html(errors)
<% else %>
  comment = $('<li/>')
  comment.attr('id', 'comment_<%= @comment.id %>')
  comment.append("<%= escape_javascript render(partial: '/base/comment', locals: { comment: @comment, avatar_size: 48 }) %>")
  $('#clip_<%= @comment.clip_id %> ul.comments').append(comment)
  $('#clip_<%= @comment.clip_id %> input').attr('value', '')
  $('#container').masonry('reload')
<% end %>
