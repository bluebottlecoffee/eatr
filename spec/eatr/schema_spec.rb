require 'spec_helper'

describe Eatr::Schema do
  let(:schema_file) { './spec/fixtures/schema/book.yaml' }

  describe '#transformation_pipeline' do
    let(:document) { './spec/fixtures/xml/book.xml' }

    it 'creates a Pipeline with the transformations' do
      xml_document = Eatr::Xml::Document.new(schema_file)
      books = xml_document.parse(document)
      expect(books.first.published_at).to eq(DateTime.new(2016, 11, 12, 8))
      expect(books.first.published_at_date_id).to eq(nil)
      books = xml_document.transformation_pipeline.call(books)
      expect(books.first.published_at_date_id).to eq(20161112)
    end
  end

  describe '#to_struct' do
    it 'creates a Struct from a schema' do
      schema = Eatr::Schema.new(YAML.load(File.read(schema_file)))
      expect(schema.to_struct).to eq(Struct::Book)
      schema = Eatr::Schema.new(YAML.load(File.read(schema_file)))
      expect(schema.to_struct).to eq(Struct::Book)
    end
  end
end
