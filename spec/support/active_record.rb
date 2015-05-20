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
