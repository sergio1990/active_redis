module ActiveRedis
  module QueryIterator

    def method_missing(method, *args)
      unless linked_objects.is_a? Array
        linked_objects.send method
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

    def map(&block)
      raise "Exception occured when trying call #map on #{@target}" unless linked_objects.is_a? Array
      linked_objects.map(&block)
    end

    def [](index)
      raise "Exception occured when trying call #[] on #{@target}" unless linked_objects.is_a? Array
      linked_objects[index]
    end

  end
end