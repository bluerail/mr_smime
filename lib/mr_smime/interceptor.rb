module MrSmime
  class Interceptor
    class << self
      def delivering_email(message)
        return message unless MrSmime.configuration.enabled

        encrypted_message = Mail.new(encrypted_data(message, signed_data(message, message.encoded)))

        overwrite_body(message, encrypted_message)
        overwrite_headers(message, encrypted_message)
      end

      def signed_data(message, data)
        Signer.new(message).signed_data(data)
      end

      def encrypted_data(message, data)
        Encrypter.new(message).encrypted_data(data)
      end

      def overwrite_body(message, encrypted_message)
        message.body = nil
        message.body = encrypted_message.body.encoded
      end

      def overwrite_headers(message, encrypted_message)
        message.content_disposition = encrypted_message.content_disposition if encrypted_message.content_disposition
        message.content_transfer_encoding = encrypted_message.content_transfer_encoding
        message.content_type = encrypted_message.content_type
      end
    end
  end
end
