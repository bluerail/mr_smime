require 'openssl'

module MrSmime
  class Encrypter
    def initialize(message)
      @message = message
    end

    def encrypted_data(data)
      return data unless encryptable?

      OpenSSL::PKCS7.write_smime(
        OpenSSL::PKCS7.encrypt(
          recipient_certificates.map(&:certificate),
          data,
          cipher
        )
      )
    end

    def encryptable?
      Signer.new(@message).signable? &&
        recipient_certificates.all? { |certificate| !certificate.nil? && certificate.present? }
    end

    def cipher
      @cipher ||= OpenSSL::Cipher.new('AES-128-CBC')
    end

    def recipient_certificates
      @message.to.map do |email_address|
        Certificate.find(email_address)
      end
    end
  end
end
