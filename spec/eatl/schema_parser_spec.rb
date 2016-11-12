require "spec_helper"

describe Eatl::SchemaParser do
  it 'parses a YAML file into a schema' do
    parser = described_class.new('./spec/fixtures/schema/book.yaml')
    expect(parser.destination_struct.name).to eq('Struct::Book')
  end
end
