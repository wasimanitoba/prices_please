class Transform::SalesDetailsExtractor < ApplicationService
  REJECTED_PHRASES = ["ADD", "New", "LIMIT", "MULTI", "SALE", "LOW STOCK", /MIN\s\d/]
  REJECTED_WORDS   = %w[Ends SAVE]

  def initialize(details)
    @details = details.split(/\n/)
  end

  def call
    # By default, we try to get the price, measurement and item as so:
    price, measurement = scrubbed_details.third.split('$').filter { |part| part.match?(/\d\/\s\d[^lb]/) }.first.split('/ ')
    item               = scrubbed_details.first.split(/\d/).first.gsub(',\s|\s(', '').underscore.tr('_', ' ')

    # Next we check for an alternate way to get the name, if possible.
    name_and_measurement = item.match(/(\D*)(\d+\s\D+)/)
    item                 = name_and_measurement.first if name_and_measurement.present?

    # Leave only a numeric value
    price&.gsub!(/ea|\(est\.\)|[$]/, '')

    # In our test batch, only 25% of sales measurements were correctly extracted.
    # For the rest, they will be blank so we can overwrite the blank value, which should never be zero.
    # We infer the where the measurement is not listen along with the price, it is parsed from the item name_and_measurement.
    measurement =  if measurement.blank? || measurement.to_i == 0
                    measurement = name_and_measurement&.last.presence
                   elsif measurement.match?(/\dkg/)
                    # Explicitly set the measurement units when we see it is sold by kilogram.
                    measurement_units = 0
                    measurement       = measurement.match(/(?<number>\d)kg/)[:number]
                   end

    { price: price, package_measurement: measurement, item_name: item, details: scrubbed_details }
  rescue StandardError => e
    Rails.logger.fatal "Failed to scrape: #{e} \n #{caller_locations[1..]}"
  end

  def scrubbed_details
    @scrubbed_details ||= @details.reject do |phrase|
      REJECTED_PHRASES.include?(phrase) || REJECTED_WORDS.any? { |word| phrase.match?(word) }
    end
  end
end