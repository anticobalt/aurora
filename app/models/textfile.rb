class Textfile < ApplicationRecord
  acts_as_taggable
  # Scope has to be a block
  scope :by_join_date, -> {order("created_at DESC")}
  scope :in_home, -> {where(archived: false)}
  # Used for form
  attr_accessor :location_partial
end
