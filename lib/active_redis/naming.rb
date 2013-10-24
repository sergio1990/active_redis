module ActiveRedis

	module Naming

		def table_name
			"#{self.name.downcase.pluralize}:item:"
		end

	end

end