module ActiveRedis
	module Calculations

		def count
			ActiveRedis.connection.count_key table_name
		end

		# TODO: add same average, min, max, sum, pluck methods

	end
end