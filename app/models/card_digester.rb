class CardDigester
  attr_accessor :card_cache, :temporary_card_cache
  attr_reader :link, :set

  def initialize(link, set)
    @link = link
    @set = set
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

  def digest
    if card_box.size >= 2
    end
  end
end
