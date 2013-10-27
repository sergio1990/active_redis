module ActiveRedis

  module Naming

    def table_name(id = "")
      "#{self.name.downcase.pluralize}:item:#{id}"
    end

    def key_name
      "#{table_name}*"
    end

    def info_table_name
      "#{self.name.downcase.pluralize}:info"
    end

  end

end