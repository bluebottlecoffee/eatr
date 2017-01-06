module Eatr
  module Sql
    class TableGenerator
      def initialize(schema_path)
        @schema = Schema.new(YAML.load(File.read(schema_path)))
      end

      def statement
        <<-STATEMENT
CREATE TABLE #{@schema.table_name} (
  #{column_defs.join(",\n  ")}
);
        STATEMENT
      end

      private

      def column_defs
        @schema.flat_fields.map do |f|
          "#{f.name} #{type(f)}#{nullness(f)}"
        end
      end

      def type(f)
        case f.type
        when nil,'string',''
          if f.length
            "CHAR(#{f.length})"
          elsif f.max_length
            "VARCHAR(#{f.max_length})"
          else
            'TEXT'
          end
        when 'integer'
          'INT'
        when 'float'
          'REAL'
        when 'timestamp'
          'TIMESTAMP'
        when 'boolean'
          'BOOLEAN'
        end
      end

      def nullness(f)
        if f.required?
          " NOT NULL"
        end
      end
    end
  end
end
