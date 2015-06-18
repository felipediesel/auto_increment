# + Spec +User+
class User < ActiveRecord::Base
  auto_increment :letter_code, scope: :account_id, initial: 'A', force: true,
                               lock: true

  belongs_to :account
end
