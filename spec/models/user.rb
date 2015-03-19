class User < ActiveRecord::Base
  auto_increment column: :letter_code, scope: :account_id, initial: 'A', force: true

  belongs_to :account
end
