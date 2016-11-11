require "spec_helper"

describe Eatl::SchemaParser do
  subject(:parser) { described_class.new }

  it 'parses a YAML file into a schema' do
    schema = subject.parse('./spec/fixtures/schema/book.yaml')
    expect(schema.columns.count).to eq(1)
  end
end
