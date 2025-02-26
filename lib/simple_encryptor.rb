class SimpleEncryptor
  class << self
    def encrypt(data)
      encryptor.encrypt_and_sign(data)
    end

    def decrypt(data)
      return if data.blank?
      data = URI.decode_www_form_component(data) if data.include?("%")
      encryptor.decrypt_and_verify(data) rescue nil
    end

    private

    def encryptor
      ActiveSupport::MessageEncryptor.new(secret_key, cipher: "aes-128-gcm")
    end

    def secret_key
      Rails.application.credentials.secret_key_base[0..15]
    end
  end
end
