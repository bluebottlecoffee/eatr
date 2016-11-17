require 'csv'

module Eatl
  module Csv
    class Document
      def initialize(schema_path)
        @schema = Schema.new(YAML.load(File.read(schema_path)))
      end

      def parse(csv_document_path)
        objects = []

        CSV.foreach(csv_document_path, headers: true) do |row|
          obj = @schema.to_struct.new

          @schema.input_fields.each do |field|
            obj.public_send("#{field.name}=", value_at(row, field))
          end

          objects << obj
        end

        objects
      end

      private

      def value_at(row, field)
        if text = row[field.csv_header]
          case field.type
          when 'integer' then text.to_i
          when 'float' then text.to_f
          when 'timestamp' then DateTime.parse(text)
          when 'boolean' then YAML.load(text)
          else
            text
          end
        elsif field.required?
          raise NodeNotFound, "Unable to find node at '#{field.xpath}'"
        else
          ""
        end
      end
    end
  end
end
