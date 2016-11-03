# Spec +Account+
class Account < ActiveRecord::Base
  auto_increment :code, before: :validation

  has_many :users
end
