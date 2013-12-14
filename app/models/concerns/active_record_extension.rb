module ActiveRecordExtension
  extend ActiveSupport::Concern

  module ClassMethods
    def without_record_timestamps
      self.record_timestamps = false
      result = yield
      self.record_timestamps = true
      result
    end
  end
end
