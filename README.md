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
Filter can be applied to Queries (Searches by hash key), Scans, and update
actions provided by this gem. Not all persistence actions make sense at the end
of a filtering query, such as `create`.

### Field Existence
Checks to see if a field is defined. See [attribute_exists](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Expressions.OperatorsAndFunctions.html)

Valid on field types: `any`

#### Example
`where{ foo }` or `where{ foo.exists! }`

### Value Equality
The equality of a field can be tested using `==` and not equals tested using `!=`

Valid on field types: `string`

#### Example
`where{ foo == 'bar' }` and `where{ foo != 'bar' }`

### Boolean Operators

| Logical Operator | Behavior      | Example
| -------------    | ------------- | --------
| `&`              | and           | `where{ foo == 'bar' && baz == 'nitch' }`
| <code>&#124;</code>           | or            | <code>where{ foo == 'bar' &#124; baz == 'nitch' }</code>
| `!`              | negation      | `where{ !(foo == 'bar' && baz == 'nitch') }`

## Retrieving Records
Retrieving a pre-filtered set of records is a fairly obvious use case for the
filtering abilities provided by DAW. Only a subset of what you may expect is
provided, but enumerable is mixed in, and each provides an Enumerator.

Provided methods
* `all`
* `first`
* `each` (and related enumerable methods)

### Scan vs Query
DAW will automatically preform a query when it determines it is possible,
however if a query is determined to not be appropriate, a scan will be conduced
instead. When ever possible, scan do not query. See the DynamoDB docs for why.

DAW will also extract filters on the range key whenever possible. In order to
filter on a range key to be used for a query, it must be one of the allowed
range key filters and at the top level of filters.


**NOTE:** Global Secondary Indices are not yet supported

#### How a query-able filter is identified
A scan will be performed when the search is not done via the hash key, with
exact equality. DAW will examine the boolean logic to determine if a key
condition may be extracted. For example, a query will be performed in the
following examples:

* `where{ id == '123' }`
* `where{ (id == '123') & (bar == 'baz') }`

But it will not be performed in these scenarios

* `where{ id != '123' }`
* `where{ !(id == '123') }`
* <code>where{ (id == '123') &#124; (bar == 'baz') }</code>


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### TODO:

#### Known issues
* If you specify multiple term nodes for a query it will generate an invalid
  query

#### Enhancements
* Support Global Secondary Index
* Conditions:
  * Equality
    * Partially implemented
  * Not Equals
  * less than
  * less than or equal to
  * greater than
  * greater than or equal to
  * between
  * in
  * attribute_not_exists
  * attribute_type
  * begins with
  * contains
  * size
* Query enhancements
  * Range key conditions:
    * equality
    * less than
    * less than or equal to
    * greater than
    * greater than or equal to
    * between
    * begins with
  * convert to bulk query if multiple hash key terms are specified

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dynamoid-advanced-where.
