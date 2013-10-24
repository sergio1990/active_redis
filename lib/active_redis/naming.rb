module ActiveRedis

	module Naming

		def table_name(id = "")
			"#{self.name.downcase.pluralize}:item:#{id}"
		end

		def info_table_name
			"#{self.name.downcase.pluralize}:info"
		end

	end

end