# auto_increment

![CI status](https://github.com/felipediesel/auto_increment/actions/workflows/ci.yml/badge.svg?branch=main)

[![Maintainability](https://qlty.sh/gh/felipediesel/projects/auto_increment/maintainability.svg)](https://qlty.sh/gh/felipediesel/projects/auto_increment)

`auto_increment` automatically generates sequential values for Active Record attributes.

Common use cases:

- Invoice numbers (`1`, `2`, `3`)
- Customer numbers (`1000`, `1001`, `1002`)
- Per-account sequences
- Letter sequences (`A`, `B`, ..., `Z`, `AA`, `AB`)

## Quick Start

Without the gem:

```rb
class Invoice < ApplicationRecord
  before_create :set_number

  private

  def set_number
    self.number = Invoice.maximum(:number).to_i + 1
  end
end
```

With `auto_increment`:

```rb
class Invoice < ApplicationRecord
  auto_increment :number
end
```

```rb
Invoice.create!.number #=> 1
Invoice.create!.number #=> 2
Invoice.create!.number #=> 3
```

## Installation

Add the gem to your Gemfile:

```rb
gem "auto_increment"
```

Then run:

```sh
bundle install
```

## Usage

The target column must exist in your database.

```rb
class Invoice < ApplicationRecord
  auto_increment :number
end
```

### Integer Sequences

```rb
class Invoice < ApplicationRecord
  auto_increment :number
end
```

Generated values:

```text
1
2
3
4
...
```

### Custom Starting Value

```rb
class Invoice < ApplicationRecord
  auto_increment :number, initial: 1000
end
```

Generated values:

```text
1000
1001
1002
...
```

### String Sequences

```rb
class User < ApplicationRecord
  auto_increment :code, initial: "A"
end
```

Generated values:

```text
A
B
C
...
Z
AA
AB
...
```

String sequences follow Ruby's [`String#next`](https://ruby-doc.org/3.4/String.html#method-i-next) logic. The column type is inferred from the database schema.

> **Deprecation**: Explicitly passing an initial value whose type differs from the database column type is deprecated. For example, `auto_increment :ref, initial: 1` on a `string` column will emit a warning. When `initial` is not set, the default is automatically inferred from the column type (`"1"` for string columns, `1` for integer columns).

### Scoped Sequences

Generate independent sequences within a scope:

```rb
class Invoice < ApplicationRecord
  auto_increment :number, scope: :account_id
end
```

Result:

```text
Account 1: 1, 2, 3
Account 2: 1, 2, 3
```

Multiple scopes are also supported:

```rb
class Invoice < ApplicationRecord
  auto_increment :number,
    scope: [:account_id, :year]
end
```

Result:

```text
Account 1, 2026: 1, 2, 3
Account 1, 2027: 1, 2, 3
Account 2, 2026: 1, 2, 3
```

### Using Model Scopes

`model_scope` applies one or more Active Record scopes before calculating the maximum value.

This is useful when:

- Bypassing a `default_scope`
- Including archived records
- Restricting the sequence to a subset of records

```rb
class User < ApplicationRecord
  default_scope -> { where(active: true) }

  scope :unscoped_all, -> { unscoped }

  auto_increment :code,
    scope: :account_id,
    model_scope: :unscoped_all
end
```

In this example, the sequence is calculated using all records, including inactive ones.

### Callback Timing

By default, values are assigned during `before_create`.

```rb
auto_increment :code
```

You can change when the value is generated:

| Option        | Callback            |
| ------------- | ------------------- |
| `:create`     | `before_create`     |
| `:save`       | `before_save`       |
| `:validation` | `before_validation` |

Example:

```rb
class Account < ApplicationRecord
  auto_increment :code, before: :validation

  validates :code, presence: true
end
```

### Overwriting Existing Values

By default, manually assigned values are preserved.

```rb
invoice.number = 500
invoice.save
```

To always generate a new value:

```rb
auto_increment :number, force: true
```

### Concurrency

For applications that may create records concurrently, enable locking:

```rb
auto_increment :number, lock: true
```

This locks the record used to determine the next value before assigning it.

## Options

```rb
auto_increment :number,
  scope: [:account_id, :year],
  model_scope: :unscoped_all,
  initial: 1000,
  force: true,
  lock: true,
  before: :validation
```

| Option        | Description                                                        | Default   |
| ------------- | ------------------------------------------------------------------ | --------- |
| `column`      | Column to increment. Can be integer or string.                     | `:code`   |
| `initial`     | Starting value. Must match the database column type (`Integer` for integer columns, `String` for string columns). When omitted, inferred from the column type. | `1` or `"1"` (inferred) |
| `scope`       | Restricts the sequence to matching column values.                  | `nil`     |
| `model_scope` | Applies Active Record scopes before calculating the maximum value. | `nil`     |
| `force`       | Overwrites an already assigned value.                              | `false`   |
| `lock`        | Enables locking when calculating the next value.                   | `false`   |
| `before`      | Callback timing (`:create`, `:save`, `:validation`).               | `:create` |

## How It Works

When a record is created, `auto_increment`:

1. Builds a query for the target column.
2. Applies any configured scopes.
3. Applies any configured model scopes.
4. Finds the current maximum value.
5. Calculates the next value.
6. Assigns the value during the configured callback.

The generated value is stored in a normal database column and can be queried, indexed, and validated like any other attribute.

## Compatibility

| Ruby | Rails              |
| ---- | ------------------ |
| 3.3  | 7.1, 7.2           |
| 3.4  | 7.1, 7.2, 8.0, 8.1 |
| 4.0  | 7.2, 8.0, 8.1      |

For older Ruby and Rails versions, use:

```rb
gem "auto_increment", "1.5.2"
```

## License

Released under the MIT License. See [LICENSE.txt](LICENSE.txt).
