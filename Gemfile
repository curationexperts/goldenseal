source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'

group :production do
# Use postgresql as the database for Active Record
  gem 'pg'
  gem 'therubyracer', platforms: :ruby
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'curation_concerns', github: 'projecthydra-labs/curation_concerns', ref: '87ee874'

gem 'resque'
gem 'hydra-pcdm', github: 'projecthydra-labs/hydra-pcdm', ref: '274f5e0'
gem 'hydra-works', github: 'projecthydra-labs/hydra-works', ref: 'bf57c69'
gem 'hydra-collections', github: 'projecthydra/hydra-collections', ref: 'd7864f33'
gem 'riiif', '0.1.0'
gem 'openseadragon', '0.2.0'
gem 'angularjs-rails', '~> 1.4.4'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
  gem 'capistrano-bundler'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'sqlite3'
  gem 'byebug'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rspec-rails'
  gem 'jettywrapper'
  gem 'factory_girl_rails'
  gem 'capybara'
end

gem 'rsolr', '~> 1.0.6'
gem 'devise'
gem 'devise_ldap_authenticatable'
gem 'devise-guests', '~> 0.3'
