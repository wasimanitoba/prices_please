class Transform::SalesDetailsExtractor
  REJECTED_PHRASES = ["ADD", "New", "LIMIT", "MULTI", "SALE", "LOW STOCK", /MIN\s\d/]
  REJECTED_WORDS   = %w[Ends SAVE]

  def initialize(details)
    @details = details.split(/\n/)
  end

  def self.parse(*args, **kwargs, &block)
    new(*args, **kwargs, &block).parse
  end

  def parse
    item = scrubbed_details.first.split(/\d/).first.gsub(',\s|\s(', '')

    price, measurement = scrubbed_details.third.split('$').filter { |part| part.match?(/\d\/\s\d[^lb]/) }.first.split('/ ')

    price.gsub!(/ea|\(est\.\)|[$]/, '')

    measurement =  if measurement.blank? || measurement.to_i == 0
                    nil
                   elsif measurement.match?(/\dkg/)
                    measurement_units = 0
                    measurement       = measurement.match(/(?<number>\d)kg/)[:number]
                   end

    return { price: price, package_measurement: measurement, item_name: item, details: scrubbed_details }
  rescue StandardError => e
    Rails.logger.fatal "Failed to scrape: #{e} \n #{caller_locations[1..]}"
  end

  def scrubbed_details
    @scrubbed_details ||= @details.reject do |phrase|
      REJECTED_PHRASES.include?(phrase) || REJECTED_WORDS.any? { |word| phrase.match?(word) }
    end
  end
end