require 'csv'

module Eatr
  module Csv
    ValueNotFound = Class.new(StandardError)

    class Document
      include ParseValue
      extend Forwardable

      attr_reader :schema

      def_delegator :schema,
        :transformation_pipeline

      def initialize(schema_path)
        @schema = Schema.new(YAML.load(File.read(schema_path)))
      end

      def parse(csv_document_path)
        objects = []

        CSV.foreach(csv_document_path, headers: true) do |row|
          obj = @schema.to_struct.new

          @schema.fields.each do |field|
            obj.public_send("#{field.name}=", value_at(row, field))
          end

          objects << obj
        end

        objects
      end

      private

      def value_at(row, field)
        if text = row[field.csv_header]
          parse_value(field, text)
        elsif field.value
          parse_value(field, field.value)
        elsif field.required?
          raise ValueNotFound, "Unable to find '#{field.name}' with header '#{field.csv_header}'"
        end
      end
    end
  end
end
