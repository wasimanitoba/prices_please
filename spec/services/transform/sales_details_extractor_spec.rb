require 'spec_helper'

RSpec.describe Transform::SalesDetailsExtractor, focus: true do
  subject { Transform::SalesDetailsExtractor.call(details_string) }

  let(:details_string) { "Red Seedless Grapes\n$8.71(est.)ea\n$8.80/ 1kg$3.99/ 1lb" }
  let(:details_array)  { details_string.split(/\n/) }

  it { is_expected.to include(price: "8.80", package_measurement: "1", item_name: "red seedless grapes", details: details_array) }

  context 'when measured in non-standard units' do
    let(:details_string) { "Romaine Salad Family Size\n$14.00ea\n$1.40/ 100g" }

    it { is_expected.to include(price: "1.40", package_measurement: "0.1", item_name: "romaine salad family size", details: details_array) }
  end

  context 'when the capitalized words in the input are incorrectly mangled together' do
    let(:details_string) { "PC OrganicsOrganic Bananas, Bunch\n$2.40(est.)ea\n$2.18/ 1kg$0.99/ 1lb" }

    it { is_expected.to include(price: "2.18", package_measurement: "1", item_name: "pc organics organic bananas, bunch", details: details_array, measurement_units: 0) }
  end

  context 'when sold in unmeasured packages' do
    let(:details_string) { "Cilantro1 bunch\n$1.49ea\n$1.49/ 1ea" }

    it { is_expected.to include(price: "1.49", package_measurement: nil, item_name: "cilantro", details: details_array, measurement_units: 0) }
  end
  context 'when the measurement is in the name instead of the unit price' do
    let(:details_string) { "RoosterGarlic 90 g\n$0.88ea$0.99ea\n$0.29/ 1ea" }

    it { is_expected.to include(price: "0.29", package_measurement: "0.09", item_name: "rooster garlic", details: details_array, measurement_units: 0) }
  end

  context 'when measured in non-standard units placed in the name instead of the unit price' do
    let(:details_string) { "Romaine Salad Family Size1 kg\n$14.00ea\n$1.40/ 100g" }

    it { is_expected.to include(price: "14.00", package_measurement: "1", item_name: "romaine salad family size", details: details_array, measurement_units: 0) }
  end
  context 'when measured in non-standard units placed in the name instead of the unit price' do
    let(:details_string) { "BolthouseGreen Goodness1.54 l\n$8.49ea\n$0.55/ 100ml" }

    it { is_expected.to include(price: "8.49", package_measurement: "1.54", item_name: "bolthouse green goodness", details: details_array, measurement_units: 1) }
  end

  context 'when pounds and kilograms are in the unit name' do
    let(:details_string) { "Strawberries 1LB454 g\n$6.99ea\n$1.54/ 100g" }

    it { is_expected.to include(price: "6.99", package_measurement: "0.454", item_name: "strawberries", details: details_array, measurement_units: 0) }
  end
end