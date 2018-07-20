# auto_increment

[![Build Status](https://travis-ci.org/felipediesel/auto_increment.svg?branch=master)](https://travis-ci.org/felipediesel/auto_increment)
[![Coverage Status](https://coveralls.io/repos/felipediesel/auto_increment/badge.svg?branch=master)](https://coveralls.io/r/felipediesel/auto_increment?branch=master)
[![Code Climate](https://codeclimate.com/github/felipediesel/auto_increment/badges/gpa.svg)](https://codeclimate.com/github/felipediesel/auto_increment)

auto_increment provides automatic incrementation for a integer or string fields in Rails.

## Installation

You can use auto_increment as a gem from Rails 4.2 to Rails 5.2-beta2.

To use the gem version, put the following gem requirement in your `Gemfile`:

    gem "auto_increment"


## Usage

To work with a auto increment column you used to do something like this in your model:

    before_create :set_code
    def set_code
      max_code = Operation.maximum(:code)
      self.code = max_code.to_i + 1
    end

Looks fine, but not when you need to do it over and over again. In fact auto_increment does it under the cover.

All you need to do is this:

    auto_increment :code

And your code field will be incremented


## Customizing

So you have a different column or need a scope. auto_increment provides options. You can use it like this:

    auto_increment :letter, scope: [:account_id, :job_id], model_scope: :in_account, initial: 'C', force: true, lock: false, before: :create

First argument is the column that will be incremented. Can be integer or string.

* **Scope by columns and model:**
* scope: you can define columns that will be scoped and you can use as many as you want (default: nil)
* model_scope: you can define model scopes that will be executed and you can use as many as you want (default: nil)
* **Scope by related model:**
* scope_by_related_model: you can define model scope by related model
* **Common options:**
* initial: initial value of column (default: 1)
* force: you can set a value before create and auto_increment will not change that, but if you do want this, set force to true (default: false)
* lock: you can set a lock on the max query. (default: false)
* before: you can choose a different callback to be used (:create, :save, :validation) (default: create)

### Example of auto increment by related model scope

```ruby
class User < ApplicationRecord
  belongs_to :department
  belongs_to :organization, through: :department
  
  auto_increment :in_organization_id, scope_by_related_model: :organization
end

class Department < ApplicationRecord
  has_many :users
  belongs_to :organization
end

class Organization < ApplicationRecord
  has_many :departments
  has_many :users, through: :departments
end
```

## Compatibility

Tested with Rails 4.2, 5, 5.1 and 5.2-beta2 in Ruby 2.4.3 and 2.5.0.

## License

MIT License
