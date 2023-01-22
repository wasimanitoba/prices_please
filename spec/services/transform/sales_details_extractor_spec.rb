require 'spec_helper'

RSpec.describe Transform::SalesDetailsExtractor, focus: true do
  subject { Transform::SalesDetailsExtractor.call(details_string) }

  let(:details_string) { "PC OrganicsOrganic Bananas, Bunch\n$2.40(est.)ea\n$2.18/ 1kg$0.99/ 1lb" }
  let(:details_array)  { details_string.split(/\n/) }

  it { is_expected.to include(price: "2.18", package_measurement: "1", item_name: "pc organics organic bananas, bunch", details: details_array) }
end