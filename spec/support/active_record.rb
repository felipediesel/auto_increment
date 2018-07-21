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

# +ActiveRecord+ migration for Organization
ActiveRecord::Migration.create_table :organizations do |t|
  t.string :name
end

# +ActiveRecord+ migration for Department
ActiveRecord::Migration.create_table :departments do |t|
  t.string :name
  t.integer :code_in_organization
  t.integer :organization_id
end

# +ActiveRecord+ migration for Workers
ActiveRecord::Migration.create_table :workers do |t|
  t.string :name
  t.integer :code_in_department
  t.integer :code_in_organization
  t.integer :department_id
end
