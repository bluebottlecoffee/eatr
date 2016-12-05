require 'spec_helper'

describe Eatl::Xml::SchemaGenerator do
  it 'generates a schema from a sample XML document' do
    generator = described_class.new('./spec/fixtures/xml/book.xml')
    expect(generator.schema('/book')).to eq(<<-EXPECTED)
---
name: ''
remove_namespaces: true
fields:
- name: id
  xpath: "/book/id"
  type: string
- name: author_first_name
  xpath: "/book/author/firstName"
  type: string
- name: author_last_name
  xpath: "/book/author/lastName"
  type: string
- name: publisher_name
  xpath: "/book/publisher/name"
  type: string
- name: published_at
  xpath: "/book/publishedAt"
  type: string
- name: for_sale
  xpath: "/book/forSale"
  type: string
- name: rating
  xpath: "/book/rating"
  type: string
- name: pages
  xpath: "/book/pages"
  type: string
- name: summary
  xpath: "/book/summary"
  type: string
- node: chapters
  xpath: "/book/chapters/chapter"
  children:
  - name: chapters_title
    xpath: "./title"
    type: string
EXPECTED
  end
end
