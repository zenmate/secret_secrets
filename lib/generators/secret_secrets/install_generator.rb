require 'rails/generators/base'

module SecretSecrets
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      desc "Installs SecretSecrets into your rails application."

      def copy_initializer_file
        copy_file "secret_secrets.rb", "config/initializers/secret_secrets.rb"
      end

      def copy_yaml_file
        copy_file "secret_secrets.yml", "config/secret_secrets.yml"
      end

      def update_gitignore
        append_to_file '.gitignore', '/config/secret_secrets.yml'
      end
    end
  end
end
