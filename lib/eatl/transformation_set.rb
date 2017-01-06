module Eatl
  class TransformationSet
    include Enumerable

    def initialize(transformations)
      @transformations = transformations
    end

    def each
      to_a.each do |t|
        yield t
      end
    end

    def to_a
      @transformations.map do |t|
        const = Object.const_get(t.fetch('class'))

        if t['args']
          const.new(t['args'])
        else
          const.new
        end
      end
    end
  end
end
