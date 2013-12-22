class ActionView::Helpers::FormBuilder
  # refs devise_error_messages!
  def error_messages
    return '' unless object.respond_to?(:errors)
    return '' if object.errors.empty?

    messages = object.errors.full_messages.map {|msg| "<li>#{msg}</li>" }.join
    sentence = I18n.t('errors.messages.not_saved', count: object.errors.count, resource: object.class.model_name.human.downcase)
    html = <<-HTML
      <div id="error_explanation">
        <h2>#{sentence}</h2>
        <ul>#{messages}</ul>
      </div>
    HTML

    html.html_safe
  end
end
