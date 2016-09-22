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

# +ActiveRecord+ migration for Sales
ActiveRecord::Migration.create_table :sales do |t|
  t.integer :account_id
  t.integer :status
  t.integer :sale_number
end

# +ActiveRecord+ migration for Sales
ActiveRecord::Migration.create_table :customers do |t|
  t.integer :account_id
  t.integer :customer_number
end
