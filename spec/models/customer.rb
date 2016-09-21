# + Spec +Customer+
class Customer < ActiveRecord::Base
  auto_increment :customer_number, scope: :account_id, initial: 1, on: :save, force: false
  belongs_to :account
end
