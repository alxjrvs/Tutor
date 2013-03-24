class ColorIdentityDigester

  attr_reader :card

  def initialize(card)
    @card = card
  end

  def gather_mana
    cost_colors = card.cost.match(/\|\S*\|/).to_s.split('|').reject(&:empty?)
    text_colors = card.card_text.match(/\|\S*\|/).to_s.split('|').reject(&:empty?)
    return (text_colors + cost_colors).reject(&:empty?).join('')
  end

  def digest
    CastingCostDigester.new(gather_mana, card.color_indicator).color
  end
end
