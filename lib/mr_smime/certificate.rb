require 'openssl'

module MrSmime
  class Certificate
    include OpenSSL

    def self.find(email)
      return unless exist?(email)

      new(email)
    end

    def self.exist?(email)
      new(email).present?
    end

    def self.root
      MrSmime.configuration.certificate_path
    end

    def self.filename(email, extension)
      email.tr('@', '.') + '.' + extension.to_s
    end

    def initialize(email)
      @email = email
    end

    def present?
      File.exist? certificate_path
    end

    def certificate
      X509::Certificate.new(File.read(certificate_path))
    end

    def certificate_path
      filename(:pem)
    end

    def private_key
      PKey::RSA.new(File.read(private_key_path))
    end

    def private_key_path
      filename(:key)
    end

    def filename(extension)
      File.join Certificate.root, Certificate.filename(@email, extension)
    end
  end
end
