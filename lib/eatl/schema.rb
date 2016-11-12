module Eatl
  class Schema
    def initialize(schema_hash)
      @schema = schema_hash
    end

    def input_fields
      @schema.fetch('input_fields')
    end

    def name
      @schema.fetch('name', 'schema')
    end
  end
end
