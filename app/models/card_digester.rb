class CardDigester
  include ApplicationHelper

  attr_reader :link, :expansion, :split_card

  def initialize(link, expansion, split_card = false)
    @link = link
    @expansion = expansion
    @split_card = split_card
  end

  def card_page_html
    @card_page_html ||= Nokogiri::HTML(open('http://gatherer.wizards.com/Pages' + link))
  end

  def multiverse_id
    @multiverse_id ||= link.match(/\d+/).to_s
  end

  def card_boxes
    @card_boxes ||= card_page_html.search('table.cardDetails').map {|c| CardBoxHasher.new(c, multiverse_id)}
  end

  def split_card?
    card_box.first
  end

  def digest
    card_boxes.each do |card_box|
      if card_box.is_split_card? == true && split_card == false
        CardDigester.new(card_box.split_card_link, expansion, true).digest
      end
      card = Card.where(card_box.card_hash).first_or_create
      printing = Printing.where(card_box.printing_hash.merge!(gatherer_url: link)).first_or_create
      printing.update_attributes(card_id: card.id, expansion_id: expansion.id)
      puts card.name
    end
  end
end
