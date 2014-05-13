# SecretSecrets
SuperSecrets is Encryption for Rails 4.1 secrets.

## Installation

In your `Gemfile` add:
```
gem 'secret_secrets', git: 'git://github.com/marcgreenstock/secret_secrets.git'
```
then run:
```
$ bundle install
```

Next run the generator:
```
$ rails g secret_secrets:install
```

This will create an initializer in `config/initializers/secret_secrets.rb` with:

```ruby
require 'secret_secrets'
SecretSecrets.setup do |config|
  # config.salt                  = ENV['SECRET_SECRETS_SALT']
  # config.passphrase            = ENV['SECRET_SECRETS_PASSPHRASE']
  # config.encrypted_file_name   = 'config/secret_secrets.yml.enc'
  # config.unencrypted_file_name = 'config/secret_secrets.yml'
end
```
It will also create a `config/secret_secrets.yml` and add an ignore record to your `.gitignore`
file in your root directory.

**IMPORTANT:** You do not want to commit in your `secret_secrets.yml` file to any repository.

## Usage

To encrypt your `secret_secrets.yml` file run:
```
$ SECRET_SECRETS_PASSPHRASE=your_super_secret_secret rake secret_secrets:encrypt
```

This will create a an encrypted file `config/secret_secrets.yml.enc`, feel free to commit this file.

Of course environment variables are annoying so if you use
[foreman](https://github.com/ddollar/foreman) you can create a `.env` file in your root directory
with:
```
SECRET_SECRETS_PASSPHRASE=your_super_secret_secret
```

then run:

```
$ foreman run rake secret_secrets:encrypt
```

**IMPORTANT:** If you use this method, remember to add `/.env` file to your `.gitconfig` file.

## Deployment

SecretSecrets works perfectly on Heroku or any server that has environment variables you just need
to give it the passphrase.

### Heroku

```
$ heroku config:set SECRET_SECRETS_PASSPHRASE=your_super_secret_secret
```

## secrets.yml

SuperSecrets doesn't encrypt `config/secrets.yml`, instead it makes use of
`config/secret_secrets.yml` as your encrypted and distributable secrets file by encrypting it to
`config/secret_secrets.yml.enc`.

You can however, change the config to use `secrets.yml` in your initializer.

## Tricks

Sometimes it's tricky to provision projects that have secret credentials such as AWS credentials
on team members development environments, but with SecretSecrets you can create multiple
secrets files; one for each environment just by changing the initializer like so:
```ruby
require 'secret_secrets'
SecretSecrets.setup do |config|
  if Rails.env == 'production'
    config.passphrase            = ENV['PRODUCTION_SECRET']
    config.encrypted_file_name   = 'config/secret_secrets.production.yml.enc'
    config.unencrypted_file_name = 'config/secret_secrets.production.yml'
  else
    config.passphrase            = ENV['DEVELOPMENT_SECRET']
    config.encrypted_file_name   = 'config/secret_secrets.development.yml.enc'
    config.unencrypted_file_name = 'config/secret_secrets.development.yml'
  end
end
```
This way you can commit your encrypted secrets, give developers the `DEVELOPMENT_SECRET` while
keeping the `PRODUCTION_SECRET` secret.

# &lt;blink&gt;REMEMBER: Don't commit your secrets. Add them to your .gitignore file!&lt;blink&gt;
