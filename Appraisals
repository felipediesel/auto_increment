RAILS_VERSIONS = %w(
  4.0.13
  4.1.15
  4.2.8
  5.0.2
  5.1.0
)

RAILS_VERSIONS.each do |version|
  appraise "rails_#{version}" do
    gem 'activerecord', version
    gem 'activesupport', version
  end
end
