# frozen_string_literal: true

RAILS_VERSIONS = {
  '6_0' => '6.0.6.1',
  '6_1' => '6.1.7.6',
  '7_0' => '7.0.8',
  '7_1' => '7.1.2'
}.freeze

RAILS_VERSIONS.each do |name, version|
  appraise "rails_#{name}" do
    gem 'activerecord', version
    gem 'activesupport', version
  end
end
