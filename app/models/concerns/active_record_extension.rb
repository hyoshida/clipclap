module ActiveRecordExtension
  extend ActiveSupport::Concern

  included do
    def force_update_attributes(*args)
      self.partial_updates = false
      result = self.update_attributes(*args)
      self.partial_updates = true
      result
    end
  end

  module ClassMethods
    def without_record_timestamps
      self.record_timestamps = false
      result = yield
      self.record_timestamps = true
      result
    end
  end
end
