require 'secret_secrets'
SecretSecrets.setup do |config|
  # config.salt                  = ENV['SECRET_SECRETS_SALT']
  # config.passphrase            = ENV['SECRET_SECRETS_PASSPHRASE']
  # config.encrypted_file_name   = 'config/secret_secrets.yml.enc'
  # config.unencrypted_file_name = 'config/secret_secrets.yml'
end
