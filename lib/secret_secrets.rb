require 'openssl'

module SecretSecrets
  class Task < Rails::Railtie
    railtie_name :secret_secrets

    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
    end
  end

  mattr_accessor :salt
  mattr_accessor :passphrase
  mattr_accessor :encrypted_file_name
  mattr_accessor :unencrypted_file_name

  @@salt                  = ENV['SECRET_SECRETS_SALT'] || 'I <3 you'
  @@passphrase            = ENV['SECRET_SECRETS_PASSPHRASE']
  @@encrypted_file_name   = 'config/secret_secrets.yml.enc'
  @@unencrypted_file_name = 'config/secret_secrets.yml'

  def self.setup
    yield self
    self.load_secret_secrets_into_secrets
  end

  def self.load_secret_secrets_into_secrets
    if File.exists?(encrypted_file_name)
      contents = self.decrypt_file
      require "erb"
      all_secrets = YAML.load(ERB.new(contents).result) || {}
      env_secrets = all_secrets[Rails.env] || {}

      Rails.application.secrets.merge!(env_secrets.symbolize_keys)
    end
  end

  def self.encrypt_file(write=false)
    cipher   = create_cipher(true)
    buffer   = ""
    contents = ""
    File.open(unencrypted_file_name, 'rb') do |input|
      while input.read(4096, buffer)
        contents << cipher.update(buffer)
      end
      contents << cipher.final
      File.open(encrypted_file_name, 'wb') do |output|
        output.write(contents)
      end if write
      contents
    end
  end

  def self.decrypt_file(write=false)
    cipher   = create_cipher(false)
    buffer   = ""
    contents = ""
    File.open(encrypted_file_name, 'rb') do |input|
      while input.read(4096, buffer)
        contents << cipher.update(buffer)
      end
      contents << cipher.final
      File.open(unencrypted_file_name, 'wb') do |output|
        output.write(contents)
      end if write
      contents
    end
  end

  private

  def self.encrypted_file_name
    Rails.root.join(@@encrypted_file_name)
  end

  def self.unencrypted_file_name
    Rails.root.join(@@unencrypted_file_name)
  end

  def self.create_cipher(encrypt)
    cipher = OpenSSL::Cipher::Cipher.new 'AES-128-CBC'
    encrypt ? cipher.encrypt : cipher.decrypt
    cipher.pkcs5_keyivgen @@passphrase, @@salt
    cipher
  end
end
