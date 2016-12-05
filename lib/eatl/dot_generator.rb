module Eatl
  class DotGenerator
    attr_reader :tables

    DEFAULT_TEMPLATE_PATH = 'lib/eatl/dot_template.dot'

    def initialize(schema_paths, template_path: DEFAULT_TEMPLATE_PATH)
      @tables = Array[schema_paths].flatten.map { |s| Schema.new(YAML.load(File.read(s))) }
      @template_path = template_path
    end

    def to_dot
      ERB.new(File.read(@template_path), nil, '-').result(binding)
    end
  end
end
