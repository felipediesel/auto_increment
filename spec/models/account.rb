# frozen_string_literal: true

# Spec +Account+
class Account < ActiveRecord::Base
  auto_increment :code, before: :validation

  has_many :users

  scope :only_mark, -> { where(name: "Mark") }
end
