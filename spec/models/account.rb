# Spec +Account+
class Account < ActiveRecord::Base
  auto_increment

  has_many :users
end
