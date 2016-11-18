require 'spec_helper'

describe Eatl::Xml::SchemaGenerator do
  it 'generates a schema from a sample XML document' do
    generator = described_class.new('./spec/fixtures/xml/book.xml')
    expect(generator.schema('/book')).to eq(<<-EXPECTED)
---
name: ''
remove_namespaces: true
fields:
- name: author_first_name
  xpath: "/book/author/firstName"
- name: author_last_name
  xpath: "/book/author/lastName"
- name: publisher_name
  xpath: "/book/publisher/name"
- name: published_at
  xpath: "/book/publishedAt"
- name: for_sale
  xpath: "/book/forSale"
- name: rating
  xpath: "/book/rating"
- name: pages
  xpath: "/book/pages"
- node: chapters
  xpath: "/book/chapters/chapter"
  children:
  - name: chapters_title
    xpath: "./title"
EXPECTED
  end
end
