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
  gem 'haml-rails'
  gem 'html2haml'
  gem_group :development, :test do
    gem 'annotate'
    gem 'bullet'
    gem 'bundle-audit'
    gem 'rubocop-rails'
    gem 'rubocop-rails_config'
    gem 'dotenv-rails'
  end
  # Install added gems.
  run 'bundle update'

  # Ignore .env in .gitignore.
  gitignore = <<~SNIPPET
    # Ignore .env files
    .env
    .env-production
    .env-development
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
  ruborake = <<~SNIPPET

    begin
      require 'rubocop/rake_task'

      task :default => %i[rubocop test]

      desc 'Run rubocop'
      task :rubocop do
        RuboCop::RakeTask.new
      end
    rescue LoadError # No rubocop
    end
  SNIPPET
  inject_into_file(
    'Rakefile',
    ruborake
  )
  enable_cops = {
    'inherit_gem' => {
      'rubocop-rails_config' => %w[
        config/rails.yml
      ]
    },
    'require' => %w[
      rubocop-rails
    ],
    'AllCops' => {
      'NewCops' => 'enable',
      'Exclude' => %w[
        bin/**/*
        db/migrate/**/*
        db/schema.rb
      ]
    },
    'Style/Documentation' => {
      'Exclude' => %w[
        config/**/*
        spec/**/*
        test/**/*
      ]
    },
    'Metrics/BlockLength' => {
      'Exclude' => %w[
        config/**/*
        lib/tasks/auto_annotate_models.rake
        spec/**/*
        test/**/*
      ]
    }
  }.to_yaml
  inject_into_file(
    '.rubocop.yml',
    enable_cops
  )
  run 'rubocop -A', abort_on_failure: false
  git add: '.'
  git commit: "-anm 'Thanks, Rubocop!'"

  # Check the current bundle for any security issues.
  run 'bundle audit --update'
end
