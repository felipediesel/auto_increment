# + Spec +Sale+
class Sale < ActiveRecord::Base
  enum status: [:complete, :canceled]
  auto_increment :sale_number, scope: [:account_id, :status], initial: 1, on: :save, force: true
  belongs_to :account
end
