require "spec_helper"

describe Eatl do
  it "has a version number" do
    expect(Eatl::VERSION).not_to be nil
  end

  it "applies a schema to an XML document" do
    schema = './spec/fixtures/schema/book.yaml'
    document = './spec/fixtures/xml/book.xml'

    book = Eatl::SchemaParser.new(schema).apply_to(document)
    expect(book.author).to eq('greggroth')
  end
end
