json.name @card.name
json.cost @card.cost
json.super_types @card.super_types
json.card_types @card.card_types
json.sub_types @card.sub_types
json.card_text @card.card_text
json.colors @card.colors
json.color_indicator @card.color_indicator
json.color_indentity @card.color_identity
json.power @card.power
json.toughness @card.toughness

if @printing.present?
  json.raw_text @printing.raw_text
  json.rules_text @printing.rules_text
  json.rarity @printing.rarity
  json.illustrator @printing.illustrator
  json.flavor_text @printing.flavor_text
  json.watermark @printing.watermark
  json.card_number @printing.card_number
  json.multiverse_number @printing.multiverse_number
end
