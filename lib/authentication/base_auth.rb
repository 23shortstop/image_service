class BaseAuth

  def initialize
    key_path = File.join(File.dirname(__FILE__),'public_key.pem')
    @p_key = OpenSSL::PKey::RSA.new File.read key_path
  end

  class AuthError < StandardError
  end

  def decrypt(data)
    begin
      @p_key.public_decrypt(data)
    rescue Exception => e
      raise AuthError, e.message
    end
  end

end
