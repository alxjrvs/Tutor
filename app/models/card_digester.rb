class CardDigester
  include ApplicationHelper

  attr_accessor :card_cache, :temporary_card_cache
  attr_reader :link, :set

  def initialize(link)
    @link = link
  end

  def card_page_html
    @card_page_html ||= Nokogiri::HTML(open("http://gatherer.wizards.com/Pages" + link))
  end

  def multiverse_id
    @multiverse_id ||= link.match(/\d+/).to_s
  end

  def card_box
    card_page_html.search('table.cardDetails')
  end

  def power_toughness_seperator(string)
    string.split("/")
  end

  def mana_cost_seperator(html)
    xpath_search(html, "manaRow").children[3].children.map do |line|
      next unless line.attributes["alt"]
      cost_digester(line.attributes["alt"].value)
    end.join('')
  end

  def xpath_search(html, id)
    html.xpath("//div[contains(@id, \"#{id}\")]")
  end

  def card_into_create_hash(html)
    type_row = TypeLineDigester.new(xpath_search(html, "typeRow").text.gsub("Types:", "").strip)
    unless xpath_search(html, 'ptRow').empty?
       power_toughness_array = power_toughness_seperator(xpath_search(html, "ptRow").text.split(":")[1].strip)
    else
      power_toughness_array = []
    end
    color_identifier = xpath_search(html, "colorIdentifierRow").text
    card_text = CardTextDigester.new(xpath_search(html, 'textRow'))
    cost = mana_cost_seperator(xpath_search(html, 'manaRow'))
    {
    name: xpath_search(html, "nameRow").children[3].text.strip,
    power: power_toughness_array[0],
    toughness: power_toughness_array[1],
    cost: cost,
    super_types: type_row.super_types,
    sub_types: type_row.sub_types,
    card_types: type_row.types,
    colors: CastingCostDigester.new(cost, color_identifier).color,
    color_identifier: color_identifier,
    raw_text: card_text.raw_text,
    card_text: card_text.card_text,
    rules_text: card_text.rules_text,
    flavor_text: xpath_search(html, 'flavorRow').text.split(":")[1].strip,
    illustrator: xpath_search(html, 'artistRow').text.split(":")[1].strip,
    rarity: xpath_search(html, 'rarityRow').text.split(":")[1].strip,
    card_number: xpath_search(html, 'numberRow').text.split(":")[1].strip,
    multiverse_number: multiverse_id,
    }
  end
  def digest
    if card_box.size >= 2
      puts "transform/Split"
    elsif card_box.search("ul > li > a").empty? == false
      puts "split"
    else
      Card.create card_into_create_hash(card_box)
    end
  end
end
