class GathererSetScraper
  attr_writer :set_table_html, :name, :short_name, :mythicable

  def initialize(name, short_name, mythicable = false)
    @name = name
    @short_name = short_name
    @mythicable = mythicable
  end

  def url_safe_name
    name.gsub(/\s/, "%20")
  end

  def set_url
    "http://gatherer.wizards.com/Pages/Search/Default.aspx?sort=cn+&output=spoiler&method=text&set=[%22#{url_safe_name}%22]"
  end

  def set
    @set ||= Release.create(name: name, short_name: short_name, mythicable: mythicable)
  end


  def set_table_html
    @set_table_html ||= Nokogiri::HTML(open(set_url))
  end

  def scrape
    set_table_html.search('table > tr').each do |row|
      RowIntoCardDigester.new(row, set).digest
    end
  end

end
