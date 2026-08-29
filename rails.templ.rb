# frozen_string_literal: true

# Template for building Rails apps my way.

# Enable pgcrypto for UUID
# file 'db/migrate/00000000_enable_uuid.rb', <<-MIGRATION
#   # db/migrate/00000000_enable_uuid.rb
#   class EnableUuid < ActiveRecord::Migration[6.0]
#     def change
#       enable_extension 'pgcrypto'
#     end
#   end
# MIGRATION
#
# file 'config/initializers/uuid.rb', <<-CODE
#   # config/initializers/uuid.rb
#   Rails.application.config.generators do |g|
#     g.orm :active_record, primary_key_type: :uuid
#   end
# CODE

after_bundle do
  gem_group :development, :test do
    gem 'annotate'
    gem 'bullet'
    gem 'bundle-audit'
    gem 'dotenv-rails'
    gem 'rubocop-rails'
    gem 'rubocop-rails_config'
  end

  # Install added gems.
  run 'bundle update --all'

  # Ignore .env in .gitignore.
  gitignore = <<~SNIPPET
    # Ignore .env files
    .env
    .env-*
  SNIPPET
  inject_into_file(
    '.gitignore',
    gitignore
  )

  # Setup annotate
  rails_command 'g annotate:install'

  # Setup bullet
  rails_command 'g bullet:install'
  gsub_file(
    'config/environments/development.rb',
    'Bullet.alert         = true',
    'Bullet.alert         = false'
  )

  # Add SimpleCSS to layout.
  styles = <<~SNIPPET
    <%= stylesheet_link_tag 'https://unpkg.com/simpledotcss/simple.min.css' %>
    <style>
      :root { --accent: deepskyblue; --accent-bg: #f5f7ff; --accent-hover: skyblue; --marked: hotpink; }
      @media (prefers-color-scheme: dark) { :root { --accent-bg: #2b2b36; } }
    </style>
  SNIPPET
  inject_into_file(
    'app/views/layouts/application.html.erb',
    styles,
    before: '</head>'
  )

  # CSS For Rails Forms
  css = <<~SNIPPET

    label {
      display: block;
    }

  SNIPPET
  inject_into_file(
    'app/assets/stylesheets/application.css',
    css
  )

  # Create a home controller and send the root to it.
  generate(:controller, 'home index')
  route "root to: 'home#index'"

  # Setup the database, generate schema.rb, and run the tests.
  %w[db:prepare db:migrate db:test:prepare test].each do |task|
    rails_command task, abort_on_failure: true
  end

  # Initial commit
  git add: '.'
  git commit: "-anm 'Initial Commit'"

  # Run rubocop before initial commit.
  run 'rubocop -A', abort_on_failure: false
  git add: '.'
  git commit: "-anm 'Thanks, Rubocop!'"

  # Check the current bundle for any security issues.
  run 'bundle audit --update'
end
