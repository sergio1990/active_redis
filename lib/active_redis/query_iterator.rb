module ActiveRedis
  module QueryIterator

    def method_missing(method, *args)
      unless linked_objects.is_a? Array
        linked_objects.send method, *args
      else
        super
      end
    end

    def inspect
      if linked_objects.is_a? Array
        "[#{linked_objects.map{|e| e.inspect}.join(', ')}]"
      else
        linked_objects.inspect
      end
    end

    def each(&block)
      raise "Exception occured when trying call #each on #{@target}" unless linked_objects.is_a? Array
      linked_objects.each(&block)
    end

  end
end