# frozen_string_literal: true

module BudgetsHelper
  include ActionView::Helpers::DateHelper

  # Alias the duration for printing because our underlying representation is a serialized string
  def duration_as_time(duration)
    duration.inspect
  end

  def distance_of_time(duration)
    distance_of_time_in_words(duration)
  end
end
