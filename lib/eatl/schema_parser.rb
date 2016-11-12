require "yaml"
require "nokogiri"

module Eatl
  class SchemaParser
    attr_reader :destination_struct

    def initialize(schema_path)
      @schema = YAML.load(File.read(schema_path))
      field_names = @schema.fetch('input_fields').map { |f| f.fetch('name').to_sym }
      @destination_struct = Struct.new(constantize(@schema.fetch('name', 'schema')), *field_names)
    end

    def apply_to(xml_document_path)
      doc = Nokogiri::XML(File.open(xml_document_path)) do |config|
        config.strict.nonet
      end

      obj = destination_struct.new
      @schema.fetch('input_fields').each do |field|
        obj.public_send("#{field['name']}=", doc.at_xpath(field.fetch('xpath')).content)
      end

      obj
    end

    private

    def constantize(underscore_name)
      underscore_name.split('_').map(&:capitalize).join
    end
  end
end
