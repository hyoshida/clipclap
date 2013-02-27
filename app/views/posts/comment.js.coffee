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
comment.html('<%= uncomment_to @comment %>')
$('#post_<%= @comment.post_id %> ul.comments').append(comment)
$('#post_<%= @comment.post_id %> input').attr('value', '')
$('#container').masonry('reload')
<% end %>
