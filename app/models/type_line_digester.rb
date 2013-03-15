class TypeLineDigester

  CARD_TYPES = %w(Artifact Creature Land Plane Planeswalker Scheme Sorcery Instant Tribal Vanguard)
  SUPER_TYPES = %w(Basic Snow Legendary World Ongoing)

  attr_reader :string

  def initialize(string)
    @string = string
  end

  def super_types
    super_types = []
    SUPER_TYPES.each do |st|
      super_types << st if split_super_types.include? st
    end
    super_types
  end

  def sub_types
    split_sub_types
  end

  def types
    card_types = []
    CARD_TYPES.each do |ct|
      card_types << ct if split_super_types.include? ct
    end
    card_types
  end

  def split_sub_types
    split_on_dash.last.split(" ")
  end

  def split_super_types
    split_on_dash.first.split(" ")
  end

  def split_on_dash
    string.split('-')
  end
end
