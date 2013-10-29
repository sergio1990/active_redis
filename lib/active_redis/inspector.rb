module ActiveRedis
  module Inspector

    def inspect
      string = "#<#{self.class.name}:#{self.object_id} "
      fields = self.class.defined_attributes.map{|field| "#{field}: #{self.send(field)}"}
      string << fields.join(", ") << ">"
    end

  end
end