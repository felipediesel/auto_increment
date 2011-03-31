auto_increment
==============

auto_increment provides automatic incrementation for a string or integer fields in Rails.

Installation
------------

You can use auto_increment as a gem in Rails 3.

To use the gem version, put the following gem requirement in your `Gemfile`:

    gem "auto_increment"


Usage
-----

To work with a auto increment column you used to do sometihng like this in your model:

    before_create :set_code
    def set_code
      max_code = Operation.maximum(:code)
      self.code = max_code.to_i + 1
    end

Looks fine, but not when you need to do it over and over again. In fact auto_increment does it under the cover.

All you need to do is this:

    auto_increment

And your code field will be incremented


### Customizing

So you have a different column or need a scope. auto_increment provides options. You can use it like this:

    auto_increment :column => :letter, :scope => [:account_id, :job_id], :initial => 'C', :force => true

* column: the column that will be incremented. Can be integer os string (default: code)
* scope: you can define columns that will be scoped and you can use as many as you want (default: nil)
* initial: initial value of column (default: 1)
* force: you can set a value before create and auto_increment will not change that, but if you do want this, set force to true (default: false)


### Compatibility

* Tested with Rails 3.0.4 in Ruby 1.8.7 and Ruby 1.9.2

### License
MIT License. Copyright 2011 29sul Tecnologia da Informação <http://www.29sul.com.br/>
