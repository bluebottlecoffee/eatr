module Eatr
  class DotGenerator
    attr_reader :tables

    DEFAULT_TEMPLATE_PATH = "#{File.dirname(__FILE__)}/dot_template.dot"

    def initialize(schema_paths, template_path: DEFAULT_TEMPLATE_PATH)
      @tables = Array[schema_paths].flatten.map { |s| Schema.new(YAML.load(File.read(s))) }
      @template_path = template_path
    end

    def to_dot
      ERB.new(File.read(@template_path), nil, '-').result(binding)
    end

    private

    def table_included?(belongs_to_str)
      table_name, _ = belongs_to_str.split('.')
      @tables.any? { |t| t.table_name == table_name }
    end

    def arrow_target(belongs_to_str)
      table_name, column = belongs_to_str.split('.')
      "\"#{table_name}\":\"#{column}\""
    end
  end
end
