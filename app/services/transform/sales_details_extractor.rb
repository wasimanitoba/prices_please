class Transform::SalesDetailsExtractor < ApplicationService
  REJECTED_PHRASES = ["ADD", "New", "LIMIT", "MULTI", "SALE", "LOW STOCK", /MIN\s\d/]
  REJECTED_WORDS   = %w[Ends SAVE]

  def initialize(details)
    @details = details.split(/\n/)
  end

  def call
    # By default, we try to get the price, measurement and item as so:
    regex = /(?<price>(\d+).(\d+))\/\s(?<measurement>\d+(kg|g|ea))/
    price_and_measurement = scrubbed_details.third.match(regex)

    if price_and_measurement.present?
      price       = price_and_measurement[:price]
      measurement = price_and_measurement[:measurement] unless price_and_measurement[:measurement].match?(/ea/)
    end

    # replace this with another regex
    primary_name = scrubbed_details.first.         # the first line
                            split(/\d/).           # separate by number
                            first.                 # the name comes before the number
                            gsub(',\s|\s(', '')    # need to remove some punctuation and spacing

    name_and_measurement = scrubbed_details.first.match(/(?<name>\D+)(?<measurement>\d+\s(g|kg))/)

    # Next we check for an alternate way to get the name, if possible.
    # In that case, we also overwrite the price. We also do this if the price is nil.
    if (name_and_measurement.present? && !price_and_measurement[:measurement].match?(/ea/)) || (price.blank?)
      price = scrubbed_details.second.match(/\$(?<price>\d+\.\d+)ea/)[:price]
    end

    measurement = name_and_measurement[:measurement] if name_and_measurement.present?

    item = primary_name || alternate_name
    item = item.underscore.   # some capitalized words GetStuckTogetherLikeThis so we underscore_those_words_instead
                tr('_', ' '). # ....and then we split them back apart with spaces
                chomp(' ')

    # Leave only a numeric value
    price.gsub!(/ea|\(est\.\)|[$]/, '')

    # In our test batch, only 25% of sales measurements were correctly extracted.
    # For the rest, they will be blank so we can overwrite the blank value, which should never be zero.
    # We infer the where the measurement is not listen along with the price, it is parsed from the item name_and_measurement.
    measurement =  if measurement.blank? || measurement.to_i == 0
                    name_and_measurement[:measurement] if name_and_measurement.present?
                   elsif measurement.match?(/\d(\s*)g/)
                    measurement_units = 0
                    # parse non standard measurement
                    numeric_measure = (measurement.match(/(?<number>\d+)(\s*)g/)[:number].to_d / 1000)
                    # match the format of other cases
                    numeric_measure.to_s
                  elsif measurement.match?(/\d(\s*)kg/)
                    # Explicitly set the measurement units when we see it is sold by kilogram.
                    measurement_units = 0
                    measurement.match(/(?<number>\d+)(\s*)kg/)[:number]
                   else
                    measurement
                   end


    { price: price, package_measurement: measurement, item_name: item.chomp, details: scrubbed_details }
  end

  def scrubbed_details
    @scrubbed_details ||= @details.reject do |phrase|
      REJECTED_PHRASES.include?(phrase) || REJECTED_WORDS.any? { |word| phrase.match?(word) }
    end
  end
end