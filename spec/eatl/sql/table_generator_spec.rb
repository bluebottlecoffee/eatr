require 'spec_helper'
require './lib/eatl/sql/table_generator'

describe Eatl::Sql::TableGenerator do
  it 'generates a CREATE TABLE statement from a schema' do
    generator = described_class.new('./spec/fixtures/schema/book.yaml')
    expect(generator.statement).to eq(<<-EXPECTED)
CREATE TABLE book (
  id INT NOT NULL,
  author TEXT NOT NULL,
  library_id INT,
  pages INT NOT NULL,
  for_sale BOOLEAN NOT NULL,
  published_at TIMESTAMP NOT NULL,
  rating REAL NOT NULL,
  icbn TEXT,
  summary VARCHAR(15) NOT NULL,
  age INT NOT NULL
);
EXPECTED
  end
end
