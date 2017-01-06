require 'spec_helper'
require './lib/eatr/xml/schema_generator'

describe Eatr::Xml::SchemaGenerator do
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
  required: false
- name: author_first_name
  xpath: "/book/author/firstName"
  type: string
  required: false
- name: author_last_name
  xpath: "/book/author/lastName"
  type: string
  required: false
- name: publisher_name
  xpath: "/book/publisher/name"
  type: string
  required: false
- name: published_at
  xpath: "/book/publishedAt"
  type: string
  required: false
- name: for_sale
  xpath: "/book/forSale"
  type: string
  required: false
- name: rating
  xpath: "/book/rating"
  type: string
  required: false
- name: pages
  xpath: "/book/pages"
  type: string
  required: false
- name: summary
  xpath: "/book/summary"
  type: string
  required: false
- node: chapters
  xpath: "/book/chapters/chapter"
  children:
  - name: chapters_title
    xpath: "./title"
    type: string
    required: false
EXPECTED
  end
end
