class CardDigester
  include ApplicationHelper

  attr_accessor :card_cache, :temporary_card_cache
  attr_reader :link, :expansion

  def initialize(link, expansion)
    @link = link
    @expansion = expansion
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
    string.split("/").map {|s| s.strip}
  end

  def mana_cost_seperator(html)
    manarow = xpath_search(html, "manaRow")
    unless manarow.empty?
      manarow.children[3].children.map do |line|
        next unless line.attributes["alt"]
        cost_digester(line.attributes["alt"].value)
      end.join('')
    else
      ''
    end
  end

  def xpath_search(html, id)
    html.search(".//div[contains(@id, \"#{id}\")]")
  end

  def color_indicator(html)
    return nil if html == ""
    color_identifier = html.split(":", 2)[1]
    if color_identifier.include? ','
      return color_identifier.split(',').map(&:strip)
    else
      return [color_identifier.strip]
    end
  end

  def type_row(html)
    TypeLineDigester.new(xpath_search(html, "typeRow").text.gsub("Types:", "").strip)
  end

  def power_toughness_array(html)
    unless xpath_search(html, 'ptRow').empty?
       power_toughness_seperator(xpath_search(html, "ptRow").text.split(":")[1].strip)
    else
      []
    end
  end

  def card_text(html)
    card_text_finder = xpath_search(html, 'textRow')
    unless card_text_finder.empty?
      CardTextDigester.new(card_text_finder)
    else
      nil
    end
  end

  def card_into_create_hash(html)
    {
    name: xpath_search(html, "nameRow").children[3].text.strip,
    power: power_toughness_array(html)[0],
    toughness: power_toughness_array(html)[1],
    cost: mana_cost_seperator(html),
    super_types: type_row(html).super_types,
    sub_types: type_row(html).sub_types,
    card_types: type_row(html).types,
    colors: CastingCostDigester.new(mana_cost_seperator(html), color_indicator(xpath_search(html, "colorIndicatorRow").text)).color,
    color_indicator: color_indicator(xpath_search(html, "colorIndicatorRow").text),
    raw_text: card_text(html).try(&:raw_text),
    card_text: card_text(html).try(&:card_text),
    rules_text: card_text(html).try(&:rules_text),
    flavor_text: xpath_search(html, 'flavorRow').text.split(":")[1].try(&:strip),
    illustrator: xpath_search(html, 'artistRow').text.split(":")[1].try(&:strip),
    rarity: xpath_search(html, 'rarityRow').text.split(":")[1].try(&:strip),
    watermark: xpath_search(html, 'markRow').text.split(":")[1].try(&:strip),
    card_number: xpath_search(html, 'numberRow').text.split(":")[1].try(&:strip),
    multiverse_number: multiverse_id,
    expansion_id: expansion.id
    }
  end

  def digest
    if card_box.size >= 2
      cards = [Card.where(card_into_create_hash(card_box.first)).first_or_create, Card.where(card_into_create_hash(card_box.last)).first_or_create]
      cards.each {|card| puts card.name}
    elsif card_box.search("ul > li > a").empty? == false
      card = Card.where(card_into_create_hash(card_box)).first_or_create
      puts card.name
    else
      card = Card.where(card_into_create_hash(card_box)).first_or_create
      puts card.name
    end
  end
end
