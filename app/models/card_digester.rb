class CardDigester
  attr_accessor :card_cache, :temporary_card_cache
  attr_reader :link, :set

  COLOR_HASH = {
  "White" => "W",
  "Blue" => "U",
  "Black" => "B",
  "Red" => "R",
  "Green" => "G"
  }

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
      if COLOR_HASH.keys.include? line.attributes["alt"].try(&:value)
      COLOR_HASH[line.attributes["alt"].try(&:value)]
      else
        line.attributes["alt"].try(&:value)
      end
    end.join('')
  end

  def xpath_search(html, id)
    html.xpath("//div[contains(@id, \"#{id}\")]")
  end

  def card_into_create_hash(html)
    binding.pry
    type_row = TypeLineDigester.new(xpath_search(html, "typeRow".text.gsub("Types:", "").strip))
    power_toughness_array = power_toughness_seperator(xpath_Search(html, "ptRow").text)
    color_indentifier = xpath_search(html, "colorIdentifierRow").text

    cost = mana_cost_seperator(html)
    {
    name: xpath_search(html, "nameRow").children[3].text.strip,
    power: power_toughness_array[0],
    toughness: power_toughness_array[1],
    cost: cost,
    super_types: type_row.super_types,
    sub_types: type_row.sub_types,
    card_types: type_row.types,
    colors: CastingCostDigester.new(cost, color_indentifier).color,
    color_indentifier: color_indentifier,
    card_text: '' ,
    reminder_text: "",
    flavor_text: "",
    illustrator: "",
    rarity: "",
    card_number: "",
    multiverse_number: "",
    }
  end

  def digest
    if card_box.size >= 2
      puts "transform/Split"
    elsif card_box.search("ul > li > a").empty? == false
      puts "split"
      binding.pry
    else
      puts "normal"
    end
  end
end
