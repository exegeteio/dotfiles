# frozen_string_literal: true

# Template for building Rails apps my way.

# Enable pgcrypto for UUID

file 'db/migrate/00000000_enable_uuid.rb', <<-MIGRATION
  # db/migrate/00000000_enable_uuid.rb
  class EnableUuid < ActiveRecord::Migration[6.0]
    def change
      enable_extension 'pgcrypto'
    end
  end
MIGRATION

file 'config/initializers/uuid.rb', <<-CODE
  # config/initializers/uuid.rb
  Rails.application.config.generators do |g|
    g.orm :active_record, primary_key_type: :uuid
  end
CODE

after_bundle do
  gem_group :development, :test do
    gem 'bullet'
    gem 'bundle-audit'
    gem 'haml-rails'
    gem 'rubocop-rails'
  end
  # Install added gems.
  run 'bundle update'

  # Setup bullet
  rails_command 'g bullet:install'
  gsub_file(
    'config/environments/development.rb',
    'Bullet.alert         = true',
    'Bullet.alert         = false'
  )

  # Add SimpleCSS to layout.
  inject_into_file(
    'app/views/layouts/application.html.erb',
    "<%= stylesheet_link_tag 'https://unpkg.com/simpledotcss/simple.min.css' %>",
    before: '</head>'
  )

  # HTML Navigation
  nav = <<-SNIPPET
  <header>
    <nav>
      <%= link_to 'Home', root_path %>
    </nav>
  </header>
SNIPPET
  inject_into_file(
    'app/views/layouts/application.html.erb',
    nav,
    after: '<body>'
  )

  # HTML Footer
  footer = <<-SNIPPET
  <footer>
    <%= link_to 'Home', root_path %>
  </footer>
SNIPPET
  inject_into_file(
    'app/views/layouts/application.html.erb',
    footer,
    before: '</body>'
  )

  # Transition to HAML
  rails_command 'haml:erb2haml HAML_RAILS_DELETE_ERB=true'

  # Create a home controller and send the root to it.
  generate(:controller, 'home index')
  route "root to: 'home#index'"

  # Setup the database, generate schema.rb, and run the tests.
  %w[db:create db:migrate db:seed db:test:prepare test].each do |task|
    rails_command task, abort_on_failure: true
  end

  # Initial commit
  git add: '.'
  git commit: "-anm 'Initial Commit'"

  # Run rubocop before initial commit.
  run 'rubocop --init'
  run 'rubocop -a', abort_on_failure: false
  git add: '.'
  git commit: "-anm 'Thanks, Rubocop!'"

  # Check the current bundle for any security issues.
  run 'bundle audit --update'
end
