$('#clip_<%= @comment.clip_id %> ul.comments li#comment_<%= @comment.id %>').remove()
$('#container').masonry('reload')
