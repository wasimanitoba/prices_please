# frozen_string_literal: true

module Shoppable
  extend ActiveSupport::Concern

  included { ; }

  class_methods do
    def js_columns; end
  end
end
