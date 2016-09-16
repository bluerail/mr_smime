require 'openssl'

module MrSmime
  class Signer
    def initialize(message)
      @message = message
    end

    def signed_data(data)
      return data unless signable?

      OpenSSL::PKCS7.write_smime(
        OpenSSL::PKCS7.sign(
          sender_certificate.certificate,
          sender_certificate.private_key,
          data,
          [],
          OpenSSL::PKCS7::DETACHED
        )
      )
    end

    def signable?
      @message.from.length == 1 &&
        !sender_certificate.nil? &&
        sender_certificate.present?
    end

    def sender_certificate
      sender_certificates.first
    end

    def sender_certificates
      @message.from.map do |email_address|
        Certificate.find email_address
      end
    end
  end
end
