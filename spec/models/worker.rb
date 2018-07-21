# + Spec +Worker+
class Worker < ActiveRecord::Base
  belongs_to :department
  delegate :organization, to: :department

  auto_increment :code_in_department, scope_by_related_model: :department
  auto_increment :code_in_organization, scope_by_related_model: :organization
end
