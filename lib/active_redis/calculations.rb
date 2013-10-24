module ActiveRedis
	module Calculations

		def count
			ActiveRedis.connection.count_key table_name
		end

	end
end