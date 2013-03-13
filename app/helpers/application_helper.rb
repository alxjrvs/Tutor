module ApplicationHelper

  COLOR_ORDER = {
    "White" => 1,
    "Blue" => 2,
    "Black" => 3,
    "Red" => 4,
    "Green" => 5
  }

  def color_sort(array)
    new_array = []
    array.each do |m|
      new_array[COLOR_ORDER[m]] = m
    end
    new_array.compact
  end
end
