module ActiveRedis
  module Inspector

    def inspect
      string = "#<#{self.class.name}:#{self.object_id} "
      fields = self.class.attributes_list.map{|field| val = self.send(field); "#{field}: #{val ? val : 'nil'}"}
      string << fields.join(", ") << ">"
    end

  end
end