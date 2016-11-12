require "yaml"
require "nokogiri"

module Eatl
  class SchemaParser
    attr_reader :destination_struct

    def initialize(schema_path)
      @schema = Schema.new(YAML.load(File.read(schema_path)))
      @destination_struct = Struct.new(constantize(@schema.name), *field_names(@schema))
    end

    def apply_to(xml_document_path)
      doc = Nokogiri::XML(File.open(xml_document_path)) do |config|
        config.strict.nonet
      end

      cardinality = @schema.input_fields.inject(1) do |memo, field|
        if field.has_key?('node')
          memo * doc.xpath(field.fetch('xpath')).count
        else
          memo
        end
      end

      objects = []

      cardinality.times do |n|
        objects << destination_struct.new
      end

      @schema.input_fields.each do |field|
        objects = set_field(objects, doc, field)
      end

      if objects.count == 1
        objects.first
      else
        objects
      end
    end

    private

    def set_field(objects, doc, field)
      if field.has_key?('name')
        objects.each do |o|
          o.public_send("#{field['name']}=", value_at(doc, field))
        end
      elsif field.has_key?('node')
        doc.xpath(field.fetch('xpath')).each_with_index do |child_xml, idx|
          field.fetch('children').flat_map do |child|
            set_field([objects[idx]], child_xml, child)
          end
        end
      end

      objects
    end

    def field_names(schema)
      schema.input_fields.select { |f| f['name'] }.
        concat(schema.input_fields.flat_map { |f| f['children'] }.compact).
        map { |f| f.fetch('name').to_sym }
    end

    def constantize(underscore_name)
      underscore_name.split('_').map(&:capitalize).join
    end

    def value_at(doc, field)
      text = doc.at_xpath(field.fetch('xpath')).content

      case field['type'].to_s.downcase
      when 'integer' then text.to_i
      else
        text
      end
    end
  end
end
