require 'openssl'

module SecretSecrets
  mattr_accessor :salt
  mattr_accessor :passphrase
  mattr_accessor :encrypted_file_name
  mattr_accessor :unencrypted_file_name
  mattr_accessor :encryption_method

  @@salt                  = ENV['SECRET_SECRETS_SALT'] || 'I <3 you'
  @@passphrase            = ENV['SECRET_SECRETS_PASSPHRASE']
  @@encrypted_file_name   = 'config/secret_secrets.yml.enc'
  @@unencrypted_file_name = 'config/secret_secrets.yml'
  @@encryption_method     = 'AES-128-CBC'

  def self.setup
    yield self if block_given?
    engine.load_secrets
  end

  def self.engine
    @engine ||= Engine.new({
      salt:                  self.salt,
      passphrase:            self.passphrase,
      encrypted_file_name:   self.encrypted_file_name,
      unencrypted_file_name: self.unencrypted_file_name,
      encryption_method:     self.encryption_method
    })
  end

  def self.decrypt_file(write=false)
    engine.decrypt_file(write)
  end

  def self.encrypt_file(write=false)
    engine.encrypt_file(write)
  end

  class Task < Rails::Railtie
    railtie_name :secret_secrets

    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
    end
  end

  class Engine
    attr_accessor :salt
    attr_accessor :passphrase
    attr_accessor :encrypted_file_name
    attr_accessor :unencrypted_file_name
    attr_accessor :encryption_method

    def initialize(attrs={})
      attrs.each {|key, val| self.send("#{key}=", val) }
    end

    def load_secrets
      if (yaml = load_file)
        require "erb"
        all_secrets = YAML.load(ERB.new(yaml).result) || {}
        env_secrets = all_secrets[Rails.env] || {}
        Rails.application.secrets.merge!(env_secrets.symbolize_keys)
      end
    end

    def encrypt_file(write=false)
      parse_file(:encrypt, unencrypted_file_path, write && encrypted_file_path)
    end

    def decrypt_file(write=false)
      parse_file(:decrypt, encrypted_file_path, write && unencrypted_file_path)
    end

    private

    def load_file
      if File.exists?(unencrypted_file_path)
        IO.read(unencrypted_file_path)
      elsif File.exists?(encrypted_file_path)
        decrypt_file
      else
        false
      end
    end

    def parse_file(mode, source, target=nil)
      cipher = create_cipher(mode)
      result = cipher.update(IO.read(source))
      result << cipher.final
      File.open(target, 'wb') do |output|
        output.write(result)
      end if target
      result
    end

    def encrypted_file_path
      Rails.root.join(encrypted_file_name).to_s
    end

    def unencrypted_file_path
      Rails.root.join(unencrypted_file_name).to_s
    end

    def create_cipher(mode)
      cipher = OpenSSL::Cipher::Cipher.new encryption_method
      mode == :encrypt ? cipher.encrypt : cipher.decrypt
      unless passphrase && salt
        puts %Q(
Need passphrase and salt to run with secret_secrets gem.
Either append them on the command line or put them into .env file
and use foreman to run your rails commands.

Example:
SECRET_SECRETS_SALT=xxx SECRET_SECRETS_PASSPHRASE=yyy rails s

With foreman and .env file:
echo -e "SECRET_SECRETS_SALT=xxx\\nSECRET_SECRETS_PASSPHRASE=yyy" > .env
foreman run rails s


To eliminate the need of foreman / environment variables,
you can always decrypt your secrets:
foreman run bundle exec rake secret_secrets:decrypt
        )

        exit 1
      end
      cipher.pkcs5_keyivgen passphrase, salt
      cipher
    end
  end
end
