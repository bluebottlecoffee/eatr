require "yaml"

module Eatl
  class SchemaParser
    def parse(schema_path)
      Schema.new(YAML.load(File.read(schema_path)).fetch('columns'))
    end
  end
end
