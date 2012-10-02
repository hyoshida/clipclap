class InclusionHtmlValidator < ActiveModel::EachValidator
  def include_image_tag?(body)
    require 'hpricot'
    doc = Hpricot(body)
    (doc/:img).present?
  end

  def validate_each(record, attribute, value)
    options[:tags].each do |tag|
      record.errors.add(attribute, "not contains <#{tag}> tag.") unless include_image_tag? value
    end
  end
end
