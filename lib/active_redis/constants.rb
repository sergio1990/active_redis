module ActiveRedis
  module Constants

    CALCULATION_METHODS = %w{count min max sum pluck}

    SAVE_SUCCESS_ANSWER = "OK"

    DEFAULT_ATTRIBUTES = {id: :integer, created_at: :time, updated_at: :time}

  end
end