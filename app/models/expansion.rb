class Expansion < ActiveRecord::Base
  has_many :printings
  has_many :cards, through: :printings
  belongs_to :block
end
