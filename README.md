# Eatl

Configuration-based XML parsing library.  Define structs in YAML configuration
files and parse XML documents to create and populate the structs.

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
input_fields:
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
> chapters = Eatl::Document.new('./spec/fixtures/schema/book.yaml' ).parse('./spec/fixtures/xml/book.xml' )
=> [#<struct Struct::Chapters author="greggroth", title="Ch 1">,
 #<struct Struct::Chapters author="greggroth", title="Ch 2">]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bluebottlecoffee/eatl. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

