# + Spec +Department+
class Department < ActiveRecord::Base
  has_many :workers
  belongs_to :organization

  auto_increment :code_in_organization, scope_by_related_model: :organization
end
