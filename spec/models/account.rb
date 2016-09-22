# Spec +Account+
class Account < ActiveRecord::Base
  auto_increment :code

  has_many :users
  has_many :sales
  has_many :customers
end
