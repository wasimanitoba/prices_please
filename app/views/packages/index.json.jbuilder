# frozen_string_literal: true

json.array! @packages, partial: 'packages/package', as: :package
