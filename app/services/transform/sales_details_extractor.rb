class Transform::SalesDetailsExtractor < ApplicationService
  REJECTED_PHRASES = ["ADD", "New", "LIMIT", "MULTI", "SALE", "LOW STOCK", /MIN\s\d/]
  REJECTED_WORDS   = ['Ends', 'SAVE', /MIN\s\d/, /LIMIT\s\d/]

  def initialize(string)
    @string = string.split(/\n/)
  end

  def call
    name_measurement  = details.first.match /(?<name>\D+)\s*\D*(?<measurement>\d+\s(g|kg|ml))/
    price_measurement = details.third.match /(?<price>(\d+).(\d+))\/\s(?<measurement>\d+(kg|g|ea))/

    price = if (name_measurement.present? && (price_measurement.present? && !price_measurement[:measurement].match?(/ea/)))
              details.second.match(/\$(?<price>\d+\.\d+)ea/)[:price]
            elsif price_measurement.present?
              price_measurement[:price]
            end

    measurement = if name_measurement.present?
                   name_measurement[:measurement]
                 elsif price_measurement.present? && !price_measurement[:measurement].match?(/ea/)
                   price_measurement[:measurement]
                 end

    name = name_measurement.try { |r| r[:name] } || details[0].split(/\d/).first

    # -----------------------------------------------------------------------
    # Fixes name for test case 'when pounds and kilograms are in the unit name'
    override_regex = /^(?<name>\D+).*\D(?<measurement>\d+).*(g|ml|kg)/
    name           = details.first.match(override_regex)[:name] if name == 'LB'
    # Messy override...get rid of this...starting to get out of hand...
    # -----------------------------------------------------------------------

    # some capitalized words GetStuckTogetherLikeThis so we underscore_those_words_instead
    #  ....and then we split them back apart with spaces
    item = name.underscore.tr('_', ' ').chomp(' ')

    # Assume we're dealing with products packaged by weight
    @measurement_units = 0

    # When the product is packaged by volumne, we get the measurement in litres
    details[2].match(/(?<price>(\d+).(\d+))\/\s(?<measurement>\d+(ml))/).try do |_|
      # Use an instance variable because the block won't always initialize this value
      @measurement_units = 1
      measurement        = details[0].match(/(?<measurement>\d.\d+)\s(ml|l)/)[:measurement]
      price              = details[1].match(/\$(?<price>\d+\.\d+)ea/)[:price]
    end

    # Otherwise the product is packaged by weight. Get the kilogram measurement or derive it from the unit cost.
    measurement = measurement.try do
      if measurement.match?(/\d(\s*)g/)
        # parse non standard measurement
        numeric_measure = (measurement.match(/(?<unit_cost>\d+)(\s*)g/)[:unit_cost].to_d / 1000)
        # match the format of other cases
        numeric_measure.to_s
      elsif measurement.match?(/\d(\s*)kg/)
        # Explicitly set the measurement units when we see it is sold by kilogram.
        measurement.match(/(?<number>\d+)(\s*)kg/)[:number]
       else
        measurement
       end
    end

    {
      measurement_units: @measurement_units || Product.measurement_units['each_package'],
      price: price.gsub(/ea|\(est\.\)|[$]/, ''),
      package_measurement: measurement,
      item_name: item.chomp,
      details: details,
    }
  end

  def details
    @details ||= @string.reject do |phrase|
      REJECTED_PHRASES.include?(phrase) || REJECTED_WORDS.any? { |word| phrase.match?(word) }
    end
  end
end