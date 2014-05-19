require 'spec_helper'

describe SecretSecrets do
  subject do
    SecretSecrets.setup do |config|
      config.salt                  = 'whatever'
      config.passphrase            = 'its a secret'
      config.encrypted_file_name   = 'config/encrypted.yml.enc'
      config.unencrypted_file_name = 'config/unencrypted.yml'
    end
  end

  describe 'setup' do
    before do
      allow(SecretSecrets).to receive(:load_secret_secrets_into_secrets)
      subject
    end

    it 'uses the block to configure' do
      expect(SecretSecrets.salt).to eq('whatever')
      expect(SecretSecrets.passphrase).to eq('its a secret')
      expect(SecretSecrets.encrypted_file_name).to eq('config/encrypted.yml.enc')
      expect(SecretSecrets.unencrypted_file_name).to eq('config/unencrypted.yml')
    end

    it 'calls load_secret_secrets_into_secrets' do
      expect(SecretSecrets).to have_received(:load_secret_secrets_into_secrets)
    end
  end

  describe 'load_secret_secrets_into_secrets' do
    before do
      allow(File).to receive(:exists?).and_return(true)
      allow(SecretSecrets).to receive(:decrypt_file)
    end
  end

  describe 'encrypted_file_path' do
    before do
      subject
    end

    it 'returns the full file path' do
      expect(SecretSecrets.encrypted_file_path).to eq("#{File.dirname(__FILE__)}/dummy/config/encrypted.yml.enc".to_s)
    end
  end

  describe 'unencrypted_file_path' do
    before do
      subject
    end

    it 'returns the full file path' do
      expect(SecretSecrets.unencrypted_file_path).to eq("#{File.dirname(__FILE__)}/dummy/config/unencrypted.yml".to_s)
    end
  end

  describe 'write_file' do
    before do
      allow(File).to receive(:open)
    end

    it 'opens the file ready for writting' do
      e
    end
  end
end
