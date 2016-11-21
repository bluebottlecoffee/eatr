require "yaml"
require "nokogiri"

module Eatl
  module Xml
    NodeNotFound = Class.new(StandardError)

    class Document
      include ParseValue

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

        cardinality = @schema.fields.inject(1) do |memo, field|
          if field.node?
            memo * [doc.xpath(field.xpath, @namespaces).count, 1].max
          else
            memo
          end
        end

        objects = []

        cardinality.times do |n|
          objects << @schema.to_struct.new
        end

        @schema.fields.each do |field|
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
        if field.value
          field.value
        elsif node = doc.at_xpath(field.xpath, @namespaces)
          parse_value(field, node.content)
        elsif field.required?
          raise NodeNotFound, "Unable to find '#{field.name}' using xpath '#{field.xpath}'"
        end
      end
    end
  end
end
