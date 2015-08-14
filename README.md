# NormalizeXml

## Summary

NormalizeXml is used to 'normalize' AMS guideline xml so different
versions can be easily compared.

As part of normalization, all `id`s are zero'd as well as `order`
attributes. XML is also pretty-printed.

## Installation

Add this line to your gemfile:

    gem 'normalizexml'

And then execute:

    $ bundle install

or install it yourself as:

    $ gem install normalizexml

## Usage

TODO

## Testing

NormalizeXml uses RSpec for testing.

To run all existing tests:

    $ rake spec

or directly:

    $ bundle exec rspec

## TODO

## Contributing

1. Fork it ( https://github.com/jmcaffee/normalizexml/fork )
1. Clone it (`git clone git@github.com:[my-github-username]/normalizexml.git`)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Create tests for your feature branch
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

## LICENSE

NormalizeXml is licensed under the MIT license.

See [LICENSE](https://github.com/jmcaffee/normalizexml/blob/master/LICENSE) for
details.

