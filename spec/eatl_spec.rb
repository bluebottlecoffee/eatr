require "spec_helper"

describe Eatl do
  let(:document) { './spec/fixtures/xml/book.xml' }
  let(:schema) { './spec/fixtures/schema/book.yaml' }

  it "has a version number" do
    expect(Eatl::VERSION).not_to be nil
  end

  it "applies a schema to an XML document" do

    book = Eatl::SchemaParser.new(schema).apply_to(document)
    expect(book.author).to eq('greggroth')
    expect(book.pages).to eq(120)
  end

  describe "parsing one document to multiple objects" do
    let(:schema) { './spec/fixtures/schema/chapters.yaml' }

    it "returns a collection of objects" do
      chapters = Eatl::SchemaParser.new(schema).apply_to(document)
      expect(chapters.count).to eq(2)
      expect(chapters[0].title).to eq('Ch 1')
      expect(chapters[1].title).to eq('Ch 2')
    end
  end

  describe "parsing document with namespaces" do
    let(:document) { './spec/fixtures/xml/namespace_library.xml' }
    let(:schema) { './spec/fixtures/schema/namespace_library.yaml' }

    it "returns a collection of objects" do
      books = Eatl::SchemaParser.new(schema).apply_to(document)
      expect(books.count).to eq(2)
      expect(books[0].title).to eq('Handy Book 1')
      expect(books[1].title).to eq('Handy Book 2')
    end
  end
end
