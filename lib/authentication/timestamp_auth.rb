require_relative './base_auth'

class TimestampAuth < BaseAuth

  def initialize(tolerance)
    @tolerance = tolerance
    super()
  end

  def authenticate(timestamp)
    difference = Time.now.to_i - decrypt(timestamp).to_i
    raise AuthError, "Timestamp is invalid" unless difference.between?(0, @tolerance)
  end

end
