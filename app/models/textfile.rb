class Textfile < ApplicationRecord
  acts_as_taggable
  # Scope has to be a block
  scope :by_join_date, -> {order("created_at DESC")}
end
