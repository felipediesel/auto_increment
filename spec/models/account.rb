# Spec +Account+
class Account < ActiveRecord::Base
  auto_increment :code

  has_many :users
end
