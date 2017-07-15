source "https://rubygems.org"

gem "compass-rails"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "pg"
gem "rails"
gem "sass-rails"
gem "susy"
gem "uglifier"
gem  "gravtastic"

gem 'rails_12factor', group: :production
gem "watu_table_builder", :require => "table_builder", :git => "git://github.com/watu/table_builder.git"

group :development, :test do
  gem "capybara"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rake"
  gem "faker"
  gem "rspec-rails"
  gem "shoulda-matchers", require: false
  gem "coveralls", :require => false
  gem "rb-readline"
end

group :production do
  gem 'therubyracer'
  gem 'newrelic_rpm'
end
