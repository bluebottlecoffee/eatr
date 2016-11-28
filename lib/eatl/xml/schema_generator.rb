module Eatl
  module Xml
    class SchemaGenerator
      def initialize(xml_path)
        @xml_path = xml_path
      end

      def schema(starting_point)
        doc = Nokogiri::XML(File.open(@xml_path)) do |config|
          config.strict.nonet
        end

        doc.remove_namespaces!

        fields = doc.at_xpath(starting_point).element_children.flat_map do |child|
          field_def(child)
        end

        schema = {
          'name' => '',
          'remove_namespaces' => true,
          'fields' => fields
        }

        YAML.dump(schema)
      end

      private

      def field_def(child, name_prefix: '', xpath_relative_to: nil)
        if unique_children_count(child) == 1 && child.element_children.map(&:name).count > 1
          relative_path = Regexp.new(child.element_children.first.path.gsub(/\[\d+\]/, "\\[\\d+\\]"))
          node_path = child.element_children.first.path.gsub(/\[\d+\]/, "")

          {
            'node' => name_prefix + underscore(child.name),
            'xpath' => xpath_relative_to ? child.path.gsub(xpath_relative_to, ".") : node_path,
            'children' => child.element_children.first.element_children.flat_map do |c|
              field_def(c, name_prefix: "#{underscore(child.name)}_", xpath_relative_to: relative_path)
            end
          }
        elsif unique_children_count(child) >= 1
          child.element_children.flat_map do |c|
            field_def(c, name_prefix: "#{underscore(child.name)}_", xpath_relative_to: xpath_relative_to)
          end
        else
          {
            'name' => name_prefix + underscore(child.name),
            'xpath' => xpath_relative_to ? child.path.gsub(xpath_relative_to, ".") : child.path,
            'type' => 'string'
          }
        end
      end

      def unique_children_count(element)
        element.element_children.map(&:name).uniq.count
      end

      def underscore(str)
        str.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end
    end
  end
end
