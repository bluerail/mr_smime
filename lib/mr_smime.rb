require 'mail'

require 'mr_smime/certificate'
require 'mr_smime/configuration'
require 'mr_smime/encrypter'
require 'mr_smime/interceptor'
require 'mr_smime/signer'
require 'mr_smime/version'

module MrSmime
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

Mail.register_interceptor(MrSmime::Interceptor)
