class Track < ApplicationRecord
  has_many :scrobbles

  def to_s
    "#{artist} - #{name}"
  end
end
