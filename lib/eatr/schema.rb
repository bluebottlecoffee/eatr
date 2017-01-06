module Eatr
  class Schema
    class Field
      def initialize(field_attributes)
        @field_attributes = field_attributes
      end

      %w[
        name
        type
        xpath
        csv_header
        strptime
        value
        max_length
        length
        belongs_to_one
        has_many
      ].each do |f|
        define_method(f) do
          @field_attributes[f]
        end
      end

      def type
        @field_attributes['type'].to_s.downcase
      end

      def node?
        @field_attributes.has_key?('node')
      end

      def required?
        @field_attributes.fetch('required', true)
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

    def flat_fields
      @flat_fields ||= fields.select(&:name).
        concat(fields.flat_map(&:children))
    end

    def name
      @schema.fetch('name', 'schema')
    end

    def table_name
      @schema.fetch('table_name', name)
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

    def transformation_pipeline
      Pipeline.new(TransformationSet.new(@schema.fetch('transformations', [])))
    end

    private

    def constant_name
      constantize(name)
    end

    def field_names
      flat_fields.map { |f| f.name.to_sym }
    end

    def constantize(underscore_name)
      underscore_name.split('_').map(&:capitalize).join
    end

  end
end
