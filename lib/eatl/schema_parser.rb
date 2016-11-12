require "yaml"
require "nokogiri"

module Eatl
  class SchemaParser
    def initialize(schema_path)
      @schema = Schema.new(YAML.load(File.read(schema_path)))
    end

    def apply_to(xml_document_path)
      doc = Nokogiri::XML(File.open(xml_document_path)) do |config|
        config.strict.nonet
      end

      cardinality = @schema.input_fields.inject(1) do |memo, field|
        if field.node?
          memo * doc.xpath(field.xpath).count
        else
          memo
        end
      end

      objects = []

      cardinality.times do |n|
        objects << @schema.to_struct.new
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
      if field.node?
        doc.xpath(field.xpath).each_with_index do |child_xml, idx|
          field.children.flat_map do |child|
            set_field([objects[idx]], child_xml, child)
          end
        end
      elsif field.name
        objects.each do |o|
          o.public_send("#{field.name}=", value_at(doc, field))
        end
      end

      objects
    end

    def value_at(doc, field)
      text = doc.at_xpath(field.xpath).content

      case field.type
      when 'integer' then text.to_i
      else
        text
      end
    end
  end
end
