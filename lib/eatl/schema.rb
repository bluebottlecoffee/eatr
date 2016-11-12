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

    def to_struct
      Struct.new(constant_name, *field_names)
    end

    private

    def constant_name
      constantize(name)
    end

    def field_names
      input_fields.select { |f| f['name'] }.
        concat(input_fields.flat_map { |f| f['children'] }.compact).
        map { |f| f.fetch('name').to_sym }
    end

    def constantize(underscore_name)
      underscore_name.split('_').map(&:capitalize).join
    end

  end
end
