# frozen_string_literal: true

# Spec +Ticket+
class Ticket < ActiveRecord::Base
  auto_increment :serial, initial: :initial_serial

  def initial_serial
    "T-1000"
  end
end
