# frozen_string_literal: true

# Spec +Post+ — string column with default integer initial
class Post < ActiveRecord::Base
  auto_increment :ref
end
