class Card < ActiveRecord::Base

  SIMPLE_RARITY_HASH = {
  "C" => "Common",
  "U" => "Umcommon",
  "R" => "Rare",
  "M" => "Mythic Rare",
  }

  belongs_to :expansion
end
