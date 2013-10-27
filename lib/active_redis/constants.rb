module ActiveRedis
  module Constants

    CALCULATION_METHODS = %w{count min max sum pluck}

    SAVE_SUCCESS_ANSWER = "OK"

    DEFAULT_ATTRIBUTES = [:id, :created_at, :updated_at]

  end
end