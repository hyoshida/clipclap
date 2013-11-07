class ImageAspectValidator < ActiveModel::Validator
  def validate(record)
    width = record.send(options[:width])
    height = record.send(options[:height])
    record.errors.add(:base, "Aspect ratio that not meet #{options[:aspect].join(':')}.") unless avable_aspect?(width, height)
  end

  def avable_aspect?(width, height)
    horizontal_aspect = options[:aspect][0]
    vertical_aspect = options[:aspect][1]
    aspect = width / height * 1.0
    aspect < (horizontal_aspect / vertical_aspect * 1.0) && aspect > (vertical_aspect / horizontal_aspect * 1.0)
  end
end
