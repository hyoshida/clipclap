$('#post_<%= @comment.post_id %> ul.comments li#comment_<%= @comment.id %>').remove()
$('#container').masonry('reload')
