module ActiveRedis
  module Constants

    CALCULATION_METHODS = %w{count min max sum pluck}

    SAVE_SUCCESS_ANSWER = "OK"

    DEFAULT_ATTRIBUTES = {id: :integer, created_at: :time, updated_at: :time}

    ASSOCIATIONS = [:has_one, :has_many, :belongs_to]

  end
end