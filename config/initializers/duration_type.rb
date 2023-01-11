# frozen_string_literal: true

class DurationType < ActiveRecord::Type::String
  def cast(value)
    return value if value.blank? || value.is_a?(ActiveSupport::Duration)

    ActiveSupport::Duration.parse(value)
  end

  def serialize(duration)
    duration&.iso8601
  end
end

ActiveRecord::Type.register(:duration, DurationType)
