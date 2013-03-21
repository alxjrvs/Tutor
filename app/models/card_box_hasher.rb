class CardBoxHasher
  include ApplicationHelper

  attr_reader :html, :multiverse_id

  def initialize(html, multiverse_id)
    @html = html
    @multiverse_id = multiverse_id
  end

  def xpath_search(id)
    html.search(".//div[contains(@id, \"#{id}\")]")
  end

  def power_toughness_seperator(string)
    string.split("/").map {|s| s.strip}
  end

  def mana_cost_seperator
    manarow = xpath_search("manaRow")
    unless manarow.empty?
      manarow.children[3].children.map do |line|
        next unless line.attributes["alt"]
        cost_digester(line.attributes["alt"].value)
      end.join('')
    else
      ''
    end
  end

  def color_indicator(color_indicator_line)
    return nil if color_indicator_line == ""
    color_identifier = color_indicator_line.split(":", 2)[1]
    if color_identifier.include? ','
      return color_identifier.split(',').map(&:strip)
    else
      return [color_identifier.strip]
    end
  end

  def type_row
    TypeLineDigester.new(xpath_search("typeRow").text.gsub("Types:", "").strip)
  end

  def power_toughness_array
    unless xpath_search('ptRow').empty?
       power_toughness_seperator(xpath_search("ptRow").text.split(":")[1].strip)
    else
      []
    end
  end

  def card_text
    card_text_finder = xpath_search('textRow')
    unless card_text_finder.empty?
      CardTextDigester.new(card_text_finder)
    else
      nil
    end
  end

  def card_hash
    {
    name: xpath_search("nameRow").children[3].text.strip,
    power: power_toughness_array[0],
    toughness: power_toughness_array[1],
    cost: mana_cost_seperator,
    super_types: type_row.super_types,
    sub_types: type_row.sub_types,
    card_types: type_row.types,
    colors: CastingCostDigester.new(mana_cost_seperator, color_indicator(xpath_search("colorIndicatorRow").text)).color,
    color_indicator: color_indicator(xpath_search("colorIndicatorRow").text),
    card_text: card_text.try(&:card_text),
    }
  end

  def printing_hash
    {
    raw_text: card_text.try(&:raw_text),
    rules_text: card_text.try(&:rules_text),
    name: xpath_search("nameRow").children[3].text.strip,
    flavor_text: xpath_search('flavorRow').text.split(":")[1].try(&:strip),
    illustrator: xpath_search('artistRow').text.split(":")[1].try(&:strip),
    rarity: xpath_search('rarityRow').text.split(":")[1].try(&:strip),
    watermark: xpath_search('markRow').text.split(":")[1].try(&:strip),
    card_number: xpath_search('numberRow').text.split(":")[1].try(&:strip),
    multiverse_number: multiverse_id,
    }
  end
end
