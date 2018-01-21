RAILS_VERSIONS = %w(
  4.2.10
  5.0.6
  5.1.4
)

RAILS_VERSIONS.each do |version|
  appraise "rails_#{version}" do
    gem 'activerecord', version
    gem 'activesupport', version
  end
end
