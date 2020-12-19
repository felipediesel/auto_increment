RAILS_VERSIONS = %w(
  4.2.11.1
  5.0.7.2
  5.1.6.2
  5.2.2.1
  6.0.3.4
  6.1.0
)

RAILS_VERSIONS.each do |version|
  appraise "rails_#{version}" do
    gem 'activerecord', version
    gem 'activesupport', version
    if version.split('.').first.to_i < 6
      gem 'sqlite3', '1.3.13'
    end
  end
end
