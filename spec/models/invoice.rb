# frozen_string_literal: true

# Spec +Invoice+
class Invoice < ActiveRecord::Base
  belongs_to :user
  auto_increment :reference, initial: -> { "A-#{user_id}-001" }
end
