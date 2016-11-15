require "yaml"
require "nokogiri"

module Eatl
  class Document
    def initialize(schema_path)
      @schema = Schema.new(YAML.load(File.read(schema_path)))
    end

    def parse(xml_document_path)
      @namespaces = {}

      doc = Nokogiri::XML(File.open(xml_document_path)) do |config|
        config.strict.nonet
      end

      if @schema.remove_namespaces?
        doc.remove_namespaces!
        @namespaces = {}
      else
        @namespaces = doc.collect_namespaces
      end

      cardinality = @schema.input_fields.inject(1) do |memo, field|
        if field.node?
          memo * doc.xpath(field.xpath, @namespaces).count
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

      objects
    end

    private

    def set_field(objects, doc, field)
      if field.node?
        doc.xpath(field.xpath, @namespaces).each_with_index do |child_xml, idx|
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
      if node = doc.at_xpath(field.xpath, @namespaces)
        text = node.content

        case field.type
        when 'integer' then text.to_i
        when 'float' then text.to_f
        when 'timestamp' then DateTime.parse(text)
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
