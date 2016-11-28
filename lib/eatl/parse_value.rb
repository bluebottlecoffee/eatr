module Eatl
  module ParseValue
    def parse_value(field, text)
      case field.type
      when 'integer' then text.to_i
      when 'float' then text.to_f
      when 'timestamp'
        if field.strptime
          DateTime.strptime(text, field.strptime)
        else
          DateTime.parse(text)
        end
      when 'boolean' then YAML.load(text)
      else
        if field.max_length
          text[0...field.max_length]
        else
          text
        end
      end
    end
  end
end
