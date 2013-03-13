require "minitest_helper"

describe ApplicationHelper do
  context "#color_sort" do
    it "should correctly sort an array of colors" do
      color_sort(["Red", "Green", "White"]).must_equal ["White", "Red", "Green"]
      color_sort(["White"]).must_equal ["White"]
      color_sort(["White", "Blue"]).must_equal ["White", "Blue"]
      color_sort(["Green", "Blue", "White", "Black", "Red"]).must_equal ["White", "Blue", "Black", "Red", "Green"]
    end
  end
end
