class CastingCostDigester
  include ApplicationHelper

  COLOR_HASH = {
    "W" => "White",
    "U" => "Blue",
    "B" => "Black",
    "R" => "Red",
    "G" => "Green"
  }

  attr_reader :cost, :color_indicator

  def initialize(cost, color_indicator = nil)
    @cost = cost
    @color_indicator = color_indicator
  end

  def color
    @color ||= set_color
  end

  def is_colorless?
    color == ["Colorless"]
  end

  def is_monocolor?
    return false if color == ["Colorless"]
    color.count  == 1 ? true : false
  end

  def cost_array
    @cost_array ||= calculate_cost_array
  end

  def is_multicolor?
    color.count == 1 ? false : true
  end

  def converted_mana_cost
    cost_array.map do |m|
      if m.include? "/"
        if m[0] == "P"
          1
        elsif m[0].to_i != 0
          m[0]
        else
          1
        end
      elsif m.to_i != 0
        m.to_i
      elsif ["W", "U", "B", "R", "G"].include? m
        1
      else
        0
      end
    end.inject(:+)
  end

  private


  def set_color
    return [COLOR_HASH[color_indicator]] if color_indicator
   initial_color_array = color_sort(cost_array.map {|m| m.split "/"}.flatten.map {|m| COLOR_HASH[m]}.compact.uniq)
   initial_color_array.empty? ? ["Colorless"] : initial_color_array
  end

  def calculate_cost_array
    colorless_mana = cost.split(/\D/)[0].to_s
    colored_mana = cost.gsub(colorless_mana, "")
    colored_mana = if colored_mana.include? "/"
      colored_mana.split("|").map do |sub|
        sub.include?("/") ? sub : sub.split("")
      end.flatten
    else
      colored_mana.split("")
    end
    return [colorless_mana, colored_mana].flatten
  end
end
