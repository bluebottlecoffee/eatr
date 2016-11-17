module Eatl
  module ParseValue
    def parse_value(field, text)
      case field.type
      when 'integer' then text.to_i
      when 'float' then text.to_f
      when 'timestamp' then DateTime.parse(text)
      when 'boolean' then YAML.load(text)
      else
        text
      end
    end
  end
end
