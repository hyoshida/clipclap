class ImageAspectValidator < ActiveModel::Validator
  def validate(record)
    width = record.send(options[:width])
    height = record.send(options[:height])
    record.errors.add(:base, "Aspect ratio that not meet #{options[:aspect].join(':')}.") unless avable_aspect?(width, height)
  end

  def avable_aspect?(width, height)
    horizontal_aspect = options[:aspect][0].to_f
    vertical_aspect = options[:aspect][1].to_f
    aspect = width.to_f / height.to_f
    aspect <= (horizontal_aspect / vertical_aspect) && aspect >= (vertical_aspect / horizontal_aspect)
  end
end
