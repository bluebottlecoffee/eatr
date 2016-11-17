require "spec_helper"

describe Eatl::Csv::Document do
  let(:document) { './spec/fixtures/csv/movies.csv' }
  let(:schema) { './spec/fixtures/schema/movie.yaml' }

  it "applies a schema to a CSV document" do
    books = Eatl::Csv::Document.new(schema).parse(document)
    expect(books.count).to eq(2)
    expect(books[0].title).to eq('Braveheart')
    expect(books[0].rating).to eq(68)
    expect(books[0].release_year).to eq(1995)
    expect(books[0].release_date).to eq(Date.new(1995, 5, 24))
    expect(books[0].lead_actor).to eq(nil)
    expect(books[0].is_good).to eq(true)
    expect(books[1].title).to eq('The Matrix')
    expect(books[1].rating).to eq(73)
    expect(books[1].release_year).to eq(1999)
    expect(books[1].release_date).to eq(Date.new(1999, 3, 31))
  end
end
