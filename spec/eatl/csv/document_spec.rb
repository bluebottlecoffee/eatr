require "spec_helper"

describe Eatl::Csv::Document do
  let(:document) { './spec/fixtures/csv/movies.csv' }
  let(:schema) { './spec/fixtures/schema/movie.yaml' }

  it "applies a schema to a CSV document" do
    books = Eatl::Csv::Document.new(schema).parse(document)
    expect(books.count).to eq(2)
    expect(books[0].title).to eq('Braveheart')
    expect(books[0].rating).to eq(10.0)
    expect(books[0].release_year).to eq(1997)
    expect(books[1].title).to eq('The Matrix')
    expect(books[1].rating).to eq(9.8)
    expect(books[1].release_year).to eq(2000)
  end
end
