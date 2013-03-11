class GathererSetScraper
  attr_reader :name, :short_name, :mythicable

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

end
