# Eatl

Configuration-based XML and CSV document parsing library.  Define structs in
YAML configuration files and parse documents to create and populate the
structs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eatl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eatl

## Usage

The library supports creating a collection of struct of arbirary cardinality.
For example, if you're interested in capturing all the chapters from an XML
representation of a book, but also want to capture higher-level keys such as
the author:

```xml
<book>
  <author>
    <firstName>greggroth</firstName>
  </author>
  <publishedAt>2016-11-12T8:00:00Z</publishedAt>
  <rating>8.9</rating>
  <pages>120</pages>
  <chapters>
    <chapter>
      <title>Ch 1</title>
    </chapter>
    <chapter>
      <title>Ch 2</title>
    </chapter>
  </chapters>
</book>
```

You can use a schema definition like:

```yaml
name: chapters
fields:
  - name: author
    xpath: //author/firstName
    type: string
  - node: chapters
    xpath: //chapters/chapter
    children:
    - name: title
      xpath: ./title
      type: string
```

Here is an example from the test suite of using this XML and schema defintion:

```ruby
> chapters = Eatl::Xml::Document.new('./spec/fixtures/schema/book.yaml' ).parse('./spec/fixtures/xml/book.xml' )
=> [#<struct Struct::Chapters author="greggroth", title="Ch 1">,
 #<struct Struct::Chapters author="greggroth", title="Ch 2">]
```

## Common Fields

`input_field` attributes:

- `name`
  - required
  - Name of the field to be used as the `attr_accessor` in the destination struct.
- `type`
  - optional -- defaults to `string`
  - Can be
    - `boolean`
    - `float`
    - `integer`
    - `string`
    - `timestamp`
- `required`
  - optional -- defaults to `true`
  - If a node cannot be found at the given `xpath`, an `Eatl::NodeNotFound` error is raised.
- `value`
  - optional -- superceeds `xpath` or `csv_header` values
  - If set, this value will be used as the attribute's value
- `strptime`
  - optional -- only applicable if `type` is `timestamp`
  - Format string used to parse the string into a `DateTime` object
- `max_length`
  - optional -- only applicable if `type` is `string`
  - Truncate the string after `max_length` characters
- `length`
  - optional -- only applicable if `type` is `string`
  - Truncate the string after `length` characters

## Fields for `Eatl::Csv::Document` schemas

- `csv_header`
  - required
  - Name of header the field is expected to be under

## Fields for `Eatl::Xml::Document` schemas

- `xpath`
  - required
  - Path to the object in the XML document that should be used to populate this field

Node field attributes:

- `node`
  - optional
  - Name to describe this collection of nodes
- `xpath`
  - required
  - Indicates the collection of children documents to be passed to the `chilren` field definitions
- `children`:
  - required
  - Collection of normal field definitions, except their `xpath` is relative to the child document defined per the `xpath` of the parent node.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bluebottlecoffee/eatl. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

