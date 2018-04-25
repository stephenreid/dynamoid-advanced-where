# Dynamoid Advanced Where (DAW)

Dynamoid Advanced where provides a more advanced query structure for selecting,
and updating records. This is very much a work in progress and functionality is
being added as it is needed.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dynamoid_advanced_where'
```

And then execute:

    $ bundle

## Usage

The HellowWorld usage for this app is basic search and retrieval. You can
invoke DAW by calling `where` on a Dynamoid::Document (No relations yet) using
a new block form.

```ruby
class Foo
  include Dynamoid::Document

  field :bar
  field :baz
end

# Returns all records with `bar` equal to 'hello'
Foo.where{ bar == 'hello' }.all

# Advanced boolean logic is also supported

# Returns all records with `bar` equal to 'hello' and `baz` equal to 'dude'
x = Foo.where{ baz == 'dude' && bar == 'hello' }.all
```

## Filtering

## Field Filtering

## Equality


## Boolean Operators

| Logical Operator | Behavior | Example |   |
| --------------------          | --------------------- | --------------
| stat_prefix                   | nil                   | string to prefix to all outgoing stats
| exclude_rails_instrumentation | false                 | set to true to disable auto instrumentation of the rails stack
| tracer                        | `Datadog.tracer`      | The tracer to use for tracing. If nil warnings will be issued when tracing is attempted.
| logger                        | Rails Logger or STDOUT Logger      | Logger for IATT related issues




## Development

| -------------    | ------------- | --------                                     |                   |
| `&`              | and           | `where{ foo == 'bar' && baz == 'nitch' }`    |                   |
| &#124;           | or            | `where{ foo == 'bar' | baz == 'nitch' }` |
| `!`              | negation      | `where{ !(foo == 'bar' && baz == 'nitch') }` |                   |

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dynamoid-advanced-where.
