module ApplicationHelper

  COLOR_ORDER  = %w(White Blue Black Red Green )

  def color_sort(array)
    array.sort_by {|m| COLOR_ORDER.index(m)}
  end
end
