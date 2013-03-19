class CardTextDigester
  include ApplicationHelper
  attr_reader :line
  def initialize(line)
    @line = line
  end

  def raw_text
    rule_text = ''
    line.children[3].children.each do |child|
      child.children.each do |second_child|
        if second_child.name == 'i'
          second_child.children.each do |subchild|
          text = text_digester(subchild).to_s
          rule_text += text
          end
        else
          text = text_digester(second_child).to_s
          rule_text += text
        end
      end
      rule_text += "\n"
    end
    rule_text.strip
  end

  def card_text
    rule_text = ''
    line.children[3].children.each do |child|
      child.children.each do |second_child|
        if second_child.name == 'i'
          next
        else
          text = text_digester(second_child).to_s
          rule_text += text
        end
      end
      rule_text += "\n"
    end
    rule_text.strip
  end

  def rules_text
    rule_text = ""
    line.children[3].children.children.search('i').children.each do |child|
      text = text_digester(child).to_s
      rule_text += text
      rule_text += "\n" if text.include? "."
      rule_text += " "
    end
    rule_text.strip
  end

  def text_digester(element)
    if element["alt"]
      cost_digester(element["alt"])
    else
      element.text
    end
  end
end
