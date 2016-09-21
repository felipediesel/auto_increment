# auto_increment

[![Build Status](https://travis-ci.org/felipediesel/auto_increment.svg?branch=master)](https://travis-ci.org/felipediesel/auto_increment)
[![Coverage Status](https://coveralls.io/repos/felipediesel/auto_increment/badge.svg?branch=master)](https://coveralls.io/r/felipediesel/auto_increment?branch=master)
[![Code Climate](https://codeclimate.com/github/felipediesel/auto_increment/badges/gpa.svg)](https://codeclimate.com/github/felipediesel/auto_increment)

auto_increment provides automatic incrementation for a integer or string fields in Rails.

## Installation

You can use auto_increment as a gem in Rails 4 and Rails 5.

To use the gem version, put the following gem requirement in your `Gemfile`:

```ruby
gem "auto_increment"
```

## Usage

To work with a auto increment column you used to do something like this in your model:

```ruby
before_create :set_code
def set_code
  max_code = Operation.maximum(:code)
  self.code = max_code.to_i + 1
end
```

Looks fine, but not when you need to do it over and over again. In fact auto_increment does it under the cover.

All you need to do is this:

```ruby
auto_increment :code
```

And your code field will be incremented


## Customizing

So you have a different column or need a scope. auto_increment provides options. You can use it like this:
```ruby
auto_increment :letter, scope: [:account_id, :job_id], initial: 'C', force: true, lock: false, on: :save
```
First argument is the column that will be incremented. Can be integer or string.

* `scope`: you can define columns that will be scoped and you can use as many as you want (default: nil)
* `initial`: initial value of column (default: 1)
* `force`: you can set a value before create and auto_increment will not change that, but if you do want this, set force to true (default: false)
* `lock`: you can set a lock on the max query. (default: false)
* `on`: moment to auto increment value, can be `:save` or `:create` (default: `:create`)


## Compatibility

Tested with Rails 4 and Rails 5 in Ruby 2.2.5 and Ruby 2.3.1

## License

MIT License. Copyright 2011 29sul Tecnologia da Informação <http://www.29sul.com.br/>
