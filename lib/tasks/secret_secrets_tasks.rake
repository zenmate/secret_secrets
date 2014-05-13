namespace :secret_secrets do
  desc 'encrypts your secret_secrets file'
  task :encrypt => :environment do
    require 'secret_secrets'
    SecretSecrets.encrypt_file(true)
  end

  desc 'decrpyts your secret_secrets file'
  task :decrypt => :environment do
    require 'secret_secrets'
    SecretSecrets.decrypt_file(true)
  end
end
