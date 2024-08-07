# frozen_string_literal: true

# +ActiveRecord+ migration for Accounts
ActiveRecord::Migration.create_table :accounts do |t|
  t.string :name
  t.integer :code
end

# +ActiveRecord+ migration for Users
ActiveRecord::Migration.create_table :users do |t|
  t.string :name
  t.integer :account_id
  t.string :letter_code
end

# +ActiveRecord+ migration for Invoices
ActiveRecord::Migration.create_table :invoices do |t|
  t.string :reference
  t.integer :user_id
end

# +ActiveRecord+ migration for Tickets
ActiveRecord::Migration.create_table :tickets do |t|
  t.string :serial
end
