# + Spec +User+
class Organization < ActiveRecord::Base
  has_many :departments
  has_many :workers, through: :departments
end
