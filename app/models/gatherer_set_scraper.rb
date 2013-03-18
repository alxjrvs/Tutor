class GathererSetScraper
  attr_accessor :set_table_html, :name, :short_name, :mythicable

  def initialize(name, short_name)
    @name = name
    @short_name = short_name
  end

  def url_safe_name
    name.gsub(/\s/, "%20")
  end

  def set_url
    "http://gatherer.wizards.com/Pages/Search/Default.aspx?output=checklist&action=advanced&set=%5b%22#{url_safe_name}%22%5d"
  end

  def set
    @set ||= Expansion.first_or_create(name: name, short_name: short_name)
  end


  def set_table_html
    @set_table_html ||= Nokogiri::HTML(open(set_url)).search('tr.cardItem')
  end

  def scrape
    set_table_html.each do |row|
      link = row.search('a.nameLink').first['href'].gsub("..", "")
      card = CardDigester.new(link).digest
      card.update_attributes(set: set)
      puts card.name
    end
  end
end
