# + Spec +User+
class User < ActiveRecord::Base
  auto_increment :letter_code, scope: :account_id, initial: 'A', force: true,
    lock: true, model_scope: :with_mark

  belongs_to :account

  default_scope -> { where 'name <> ?', 'Mark' }

  scope :with_mark, -> { unscoped }
end
