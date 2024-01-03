# auto_increment

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/felipediesel/auto_increment/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/felipediesel/auto_increment/tree/master)
[![Code Climate](https://codeclimate.com/github/felipediesel/auto_increment/badges/gpa.svg)](https://codeclimate.com/github/felipediesel/auto_increment)

auto_increment provides automatic incrementation for a integer or string fields in Rails.

## Installation

You can use auto_increment as a gem from Rails 4.2 to Rails 6.1.

To use the gem version, put the following gem requirement in your `Gemfile`:

```rb
gem "auto_increment"
```

## Usage

To work with a auto increment column you used to do something like this in your model:

```rb
before_create :set_code
def set_code
  max_code = Operation.maximum(:code)
  self.code = max_code.to_i + 1
end
```

Looks fine, but not when you need to do it over and over again. In fact auto_increment does it under the cover.

All you need to do is this:

```rb
auto_increment :code
```

And your code field will be incremented

## Customizing

So you have a different column or need a scope. auto_increment provides options. You can use it like this:

```rb
auto_increment :letter, scope: [:account_id, :job_id], model_scope: :in_account, initial: 'C', force: true, lock: false, before: :create
```

First argument is the column that will be incremented. Can be integer or string.

- scope: you can define columns that will be scoped and you can use as many as you want (default: nil)
- model_scope: you can define model scopes that will be executed and you can use as many as you want (default: nil)
- initial: initial value of column (default: 1)
- force: you can set a value before create and auto_increment will not change that, but if you do want this, set force to true (default: false)
- lock: you can set a lock on the max query. (default: false)
- before: you can choose a different callback to be used (:create, :save, :validation) (default: create)

## Compatibility

Tested with Rails 6.1, 6 in Ruby 2.7.7.
Tested with Rails 7.1, 7, 6.1, 6 in Ruby 3.2.2.

For older versions, use version 1.5.2.

## License

[MIT License](LICENSE.txt)
