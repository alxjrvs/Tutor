module ApplicationHelper

  COLOR_ORDER  = %w(White Blue Black Red Green )

  COLOR_HASH = {
  "White" => "W",
  "Blue" => "U",
  "Black" => "B",
  "Red" => "R",
  "Green" => "G",
  }
  def color_sort(array)
    array.sort_by {|m| COLOR_ORDER.index(m)}
  end

  def cost_digester(string)
      if string.to_i != 0
        "|#{string}|"
      elsif COLOR_HASH.keys.include? string
        "|#{COLOR_HASH[string]}|"
      elsif string == "Tap"
        "|T|"
      elsif string == "Variable Colorless"
        "|X|"
      elsif string == "Untap"
        "|UT|"
      elsif string.include? "or"
        multi_color_translator(string)
      elsif string.include? "Phyrexian"
        "|P/#{string.split(" ")[1]}|"
      end
  end

  def multi_color_translator(string)
    "|#{string.split('or').map {|mana| COLOR_HASH[mana.strip]}.join('/')}|"
  end
end
