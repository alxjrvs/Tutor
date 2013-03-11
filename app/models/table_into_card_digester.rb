class TableIntoCardDigester
  attr_accessor :card_cache, :temporary_card_cache
  attr_reader :doc, :set

  def initialize(doc, set)
    @doc = doc
    @set = set
  end

  def card_cache
    @card_cache ||= {}
  end

  def temporary_card_cache
    @temporary_card_cache ||= nil
  end

  def split_merge
    "#{/(\w*)/.match(card_cache[:name]).to_s}\n#{card_cache[:cost]}\n#{card_cache[:card_type]}\n#{card_cache[:rules]}\n#{card_cache[:pow_tgh]} "
  end

  def rarity_sort(string)
    rarity = ''
    string.strip.split(",").each do |x|
      rarity  =x.gsub(set.name, '').strip if x.include? set.name
    end
  rarity
  end

  def split_check
    if temporary_card_cache
      temporary_card_cache.merge!({:name => /\w* \/\/ \w*/.match(temporary_card_cache[:name]).to_s,
      :cost => "#{temporary_card_cache[:cost]} // #{card_cache[:cost]}",
      :card_type => "#{temporary_card_cache[:card_type]} //#{card_cache[:card_type]}",
      :rules => "#{split_merge(temporary_card_cache)}\n-----\n#{split_merge(card_cache)}"}
     )
      card = Card.create temporary_card_cache
      @set.cards << card
      temporary_card_cache = nil
      card_cache ={:name => ''}
    end
    if /\w* \/\/ \w*/.match(card_cache[:name])
      temporary_card_cache = card_cache
      card_cache = {}
    end
  end

  def flip_check
    if temporary_card_cache
      if card_cache[:rules].include? "#flip {card_cache[:name]}" or @a[:rules].include? "flip it"
        temporary_card_cache[:rules] = "#{@b[:rules]}\n-----\n#{card_cache[:name]}\n#{card_cache[:card_type]}\n#{@a[:rules]}\n#{@a[:pow_tgh]}"
        card = Card.create temporary_card_cache
        @set.cards << card
        temporary_card_cache = nil
        card_cache ={:name => '', :rules => ''}
      end
    end
    if card_cache[:name].include? "("
      if card_cache[:name].include? Card.last.name
        Card.last.update_attributes(:rules => "#{Card.last.rules}\n-----\n#{card_cache[:name].gsub(Card.last.name, '')}\n#{card_cache[:card_type]}\n#{@a[:rules]}\n#{@a[:pow_tgh]}")
        card_cache = {}
      else
        temporary_card_cache = card_cache
        card_cache = {}
      end
    end
  end


  def transform_check
    binding.pry
    if temporary_card_cache
      if card_cache[:cost] == ''
        temporary_card_cache[:rules] = "#{@b[:rules]}\n-----\n#{card_cache[:name]}\n#{card_cache[:card_type]}\n#{@a[:rules]}\n#{@a[:pow_tgh]}"
        temporary_card_cache[:dfc]= true
        card = Card.create temporary_card_cache
        @set.cards << card
        temporary_card_cache = nil
        card_cache ={:rules => '', :name => ''}
      elsif temporary_card_cache[:cost] == ''
        temporary_card_cache = nil
      else 
        card = Card.create temporary_card_cache
        @set.cards << card
        temporary_card_cache = nil
      end
    end
    binding.pry
    if card_cache[:rules].include? "transform" or card_cache[:rules].include? "Transform"
      temporary_card_cache = card_cache
      card_cache = {}
    end
  end

  def power_toughness_seperator(row, pt)
    row.at_xpath('td[2]').text.strip.gsub("[()]", '').split("/")
  end

  def digest
    doc.each do |row|
      if row.at_xpath('td[2]')
        case row.at_xpath('td[1]').text.strip
        when "Name:"
         card_cache.merge!({ name: row.at_xpath('td[2]').text.strip })
          @split = true if card_cache[:name].include? '//'
        when "Cost:"
         card_cache.merge!({ cost: row.at_xpath('td[2]').text.strip.upcase })
        when "Type:"
          card_cache.merge!({ card_type: row.at_xpath('td[2]').text.strip })
        when "Rules Text:"
          card_cache.merge!({rules: row.at_xpath('td[2]').text.strip.gsub(/\r/," ")  })
        when "Flavor Text:"
          card_cache.merge!({ flavor: row.at_xpath('td[2]').text.strip })
        when "Illus."
          card_cache.merge!({ illustrator: row.at_xpath('td[2]').text.strip })
        when "Pow/Tgh:"
          card_cache.merge!({power: power_toughness_seperator(row, 'td[2]')[0]})
          card_cache.merge!({toughness: power_toughness_seperator(row, 'td[2]')[1]})
        when "Set/Rarity:"
            card_cache.merge!({ rarity: rarity_sort(row.at_xpath('td[2]').text) })
            flip_check  if set.name.include? "Kamigawa"
            split_check if @split
            transform_check if set.short_name == "ISD" or set.short_name == "DKA"
            puts "Making a card...."
            card = Card.create card_cache
            card.update_attributes(:rarity => "Token") if card.name.include? "token card"
            card_cache = {}
            set.cards << card
          p "#{card.name } saved to #{card.release.name}"
        end
      end
    end
  end
end
