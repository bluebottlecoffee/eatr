require 'spec_helper'

describe Eatl::Schema do
  describe '#transformation_pipeline' do
    let(:document) { './spec/fixtures/xml/book.xml' }
    let(:schema_file) { './spec/fixtures/schema/book.yaml' }

    it 'creates a Pipeline with the transformations' do
      xml_document = Eatl::Xml::Document.new(schema_file)
      books = xml_document.parse(document)
      expect(books.first.published_at).to eq(DateTime.new(2016, 11, 12, 8))
      expect(books.first.published_at_date_id).to eq(nil)
      books = xml_document.transformation_pipeline.call(books)
      expect(books.first.published_at_date_id).to eq(20161112)
    end
  end
end
