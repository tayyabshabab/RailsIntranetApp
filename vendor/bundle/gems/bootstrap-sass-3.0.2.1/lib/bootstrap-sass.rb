module Bootstrap
  class FrameworkNotFound < StandardError; end

  # Inspired by Kaminari
  def self.load!
    if compass?
      require 'bootstrap-sass/compass_functions'
      register_compass_extension
    elsif asset_pipeline?
      require 'bootstrap-sass/sass_functions'
    end

    if rails?
      require 'sass-rails'
      register_rails_engine
    end

    unless rails? || compass?
      raise Bootstrap::FrameworkNotFound,
            'bootstrap-sass requires either Rails > 3.1 or Compass, neither of which are loaded'
    end

    bs_stylesheets = File.join(gem_path, 'vendor', 'assets', 'stylesheets')
    ::Sass.load_paths << bs_stylesheets
    if ::Sass::Script::Number.precision < 10
      # see https://github.com/thomas-mcdonald/bootstrap-sass/issues/409
      ::Sass::Script::Number.precision = 10
    end
  end

  private

  def self.gem_path
    @gem_path ||= File.expand_path File.join('..'), File.dirname(__FILE__)
  end

  def self.asset_pipeline?
    defined?(::Sprockets)
  end

  def self.compass?
    defined?(::Compass)
  end

  def self.rails?
    defined?(::Rails)
  end

  def self.register_compass_extension
    styles    = File.join gem_path, 'vendor', 'assets', 'stylesheets'
    templates = File.join gem_path, 'templates'
    ::Compass::Frameworks.register(
        'bootstrap',
        :path                  => gem_path,
        :stylesheets_directory => styles,
        :templates_directory   => templates
    )
  end

  def self.register_rails_engine
    require 'bootstrap-sass/engine'
  end
end

Bootstrap.load!
