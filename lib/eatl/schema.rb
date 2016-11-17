module Eatl
  class Schema
    class Field
      def initialize(field_attributes)
        @field_attributes = field_attributes
      end

      def name
        @field_attributes['name']
      end

      def type
        @field_attributes['type'].to_s.downcase
      end

      def xpath
        @field_attributes['xpath']
      end

      def node?
        @field_attributes.has_key?('node')
      end

      def csv_header
        @field_attributes['csv_header']
      end

      def required?
        @field_attributes.fetch('required', true)
      end

      def strptime
        @field_attributes['strptime']
      end

      def value
        @field_attributes['value']
      end

      def children
        Array[*@field_attributes['children']].map { |f| Field.new(f) }
      end
    end

    def initialize(schema_hash)
      @schema = schema_hash
    end

    def fields
      @fields ||= @schema.fetch('fields').map { |f| Field.new(f) }
    end

    def name
      @schema.fetch('name', 'schema')
    end

    def remove_namespaces?
      @schema.fetch('remove_namespaces', false)
    end

    def to_struct
      @struct_klass ||= begin
                          Object.const_get("Struct::#{constant_name}")
                        rescue NameError
                          Struct.new(constant_name, *field_names)
                        end
    end

    private

    def constant_name
      constantize(name)
    end

    def field_names
      fields.select(&:name).
        concat(fields.flat_map(&:children)).
        map { |f| f.name.to_sym }
    end

    def constantize(underscore_name)
      underscore_name.split('_').map(&:capitalize).join
    end

  end
end
