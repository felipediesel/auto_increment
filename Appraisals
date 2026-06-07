# frozen_string_literal: true

RAILS_VERSIONS = {
  "7_1" => "7.1.6",
  "7_2" => "7.2.3.1",
  "8_0" => "8.0.5",
  "8_1" => "8.1.3"
}.freeze

RAILS_VERSIONS.each do |name, version|
  appraise "rails_#{name}" do
    gem "activerecord", version
    gem "activesupport", version
    group :development do
      gem "standard"
    end
  end
end
