require "minitest_helper"

describe CastingCostDigester do

  before do
    @mono = CastingCostDigester.new("2U")
    @multi = CastingCostDigester.new("2UURR")

    @phyrexian = CastingCostDigester.new("2|P/U|")
    @hybrid = CastingCostDigester.new("1|R/B|")
    @reaper = CastingCostDigester.new("1|2/B|")

    @expensive = CastingCostDigester.new("15U")

    @colorless = CastingCostDigester.new("15")
    @free = CastingCostDigester.new("0")
  end

  context "#color" do
    it "should digest a monocolored casting cost into a color array" do
      @mono.color.must_equal ["Blue"]
    end

    it "should digest a multicolored casting cost into a color array" do
      @multi.color.must_equal ["Blue", "Red"]
    end

    it "should digest a hybrid, phyrexian, and reaper mana cost into a color array" do
      @hybrid.color.must_equal ["Black", "Red"]
      @phyrexian.color.must_equal ["Blue"]
      @reaper.color.must_equal ["Black"]
    end

    it "should digest a colorless color array for colorless cards" do
      @colorless.color.must_equal ["Colorless"]
      @free.color.must_equal ["Colorless"]
    end
  end

  context "#is_colorless" do
    it "should return true for colorless cards" do
      @colorless.is_colorless?.must_equal true
      @free.is_colorless?.must_equal true
    end

    it "should return false for colored cards" do
      @mono.is_colorless?.must_equal false
      @multi.is_colorless?.must_equal false
      @expensive.is_colorless?.must_equal false
      @phyrexian.is_colorless?.must_equal false
      @reaper.is_colorless?.must_equal false
    end
  end

  context "#is_monocolor?" do
    it "should return true for monocolored cards" do
      @mono.is_monocolor?.must_equal true
      @expensive.is_monocolor?.must_equal true
    end

    it "should return false for multicolored and colorless cards" do
      @multi.is_monocolor?.must_equal false
      @hybrid.is_monocolor?.must_equal false
    end
  end

  context "#cost_array" do
    it "should not break up double-digit colorless mana costs" do
      @expensive.cost_array.must_equal ["15", "U"]
      @colorless.cost_array.must_equal ["15"]
    end
  end

  context "#is_multicolor?" do
    it "should return false for monocolored and colorless cards" do
      @mono.is_multicolor?.must_equal false
      @phyrexian.is_multicolor?.must_equal false
      @reaper.is_multicolor?.must_equal false
      @colorless.is_multicolor?.must_equal false
      @free.is_multicolor?.must_equal false
    end

    it "should return true for multicolored cards" do
      @hybrid.is_multicolor?.must_equal true
      @multi.is_multicolor?.must_equal true
    end

  end

  context "#converted_mana_cost" do
    it "should digest mana symbols correctly" do
      @mono.converted_mana_cost.must_equal 3
      @multi.converted_mana_cost.must_equal 6
    end

    it "should ignore x in cost" do
      CastingCostDigester.new("XR").converted_mana_cost.must_equal 1
      CastingCostDigester.new("XXG").converted_mana_cost.must_equal 1
    end
  end
end
