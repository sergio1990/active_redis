module ActiveRedis

  class NoConnectionError < ::StandardError
  end

  class NoLogError < ::StandardError
  end

  class NotSpecifiedIdError < ::StandardError
  end

  class InvalidArgumentError < ::StandardError
  end

  class UnregisteredAssociationError < ::StandardError
  end

end