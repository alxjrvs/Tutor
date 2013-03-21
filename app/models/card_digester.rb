class CardDigester
  include ApplicationHelper

  attr_accessor :card_cache, :temporary_card_cache
  attr_reader :link, :expansion

  def initialize(link, expansion)
    @link = link
    @expansion = expansion
  end

  def card_page_html
    @card_page_html ||= Nokogiri::HTML(open('http://gatherer.wizards.com/Pages' + link))
  end

  def multiverse_id
    @multiverse_id ||= link.match(/\d+/).to_s
  end

  def card_boxes
    card_page_html.search('table.cardDetails').map {|c| CardBoxHasher.new(c, multiverse_id)}
  end

  def digest
    card_boxes.each do |card_box|
      card = Card.where(card_box.card_hash).first_or_create
      printing = Printing.where(card_box.printing_hash).first_or_create
      printing.update_attributes(card_id: card.id, expansion_id: expansion.id)
      puts card.name
    end
  end
end
