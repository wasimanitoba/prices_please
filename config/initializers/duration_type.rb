# frozen_string_literal: true

class DurationType < ActiveRecord::Type::String
  def cast(value)
    return value if value.blank? || value.is_a?(ActiveSupport::Duration)

    if value.match?(/\d\d-\d\d-\d\d\d\d\s-\s\d\d-\d\d-\d\d\d\d/)
      start_date, end_date = value.split(' - ')

      duration_as_float = Time.parse(end_date).at_end_of_day - Time.parse(start_date).at_beginning_of_day

      duration = ActiveSupport::Duration.parse(duration_as_float.seconds.iso8601)

      return duration
    end

    ActiveSupport::Duration.parse(value)
  end

  def serialize(duration)
    duration&.iso8601
  end
end

ActiveRecord::Type.register(:duration, DurationType)
