class Card < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  SIMPLE_RARITY_HASH = {
  "C" => "Common",
  "U" => "Umcommon",
  "R" => "Rare",
  "M" => "Mythic Rare",
  }

  has_many :printings
  has_many :expansions, through: :printings

end
