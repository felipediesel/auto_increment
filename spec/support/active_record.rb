ActiveRecord::Migration.create_table :accounts do |t|
  t.string :name
  t.date :code
end

ActiveRecord::Migration.create_table :users do |t|
  t.string :name
  t.integer :account_id
  t.string :letter_code
end
