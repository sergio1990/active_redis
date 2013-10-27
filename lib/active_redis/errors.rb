module ActiveRedis

  class NoConnectionError < ::StandardError
  end

  class NotSpecifiedIdError < ::StandardError
  end

  class InvalidArgumentError < ::StandardError
  end

end