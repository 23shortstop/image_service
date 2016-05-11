class BaseAuth

  def initialize
    @p_key = OpenSSL::PKey::RSA.new File.read ENV['AUTH_KEY_PATH']
  end

  class AuthError < StandardError
    def initialize
      super 'Access is denied'
    end
  end

  def decrypt(data)
    begin
      @p_key.public_decrypt(data)
    rescue Exception => e
      raise AuthError
    end
  end

end
