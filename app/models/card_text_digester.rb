class CardTextDigester
  include ApplicationHelper
  attr_reader :line
  def initialize(line)
    @line = line
  end

  def raw_text
    rule_text = ''
    line.children[3].children.children.each do |child|
      if child.name == 'i'
        child.children.each do |subchild|
          rule_text += text_digester(subchild)
        end
      else
        rule_text += text_digester(child)
      end
      rule_text += "\n"
    end
    rule_text
  end

  def card_text
    rule_text = ''
    line.children[3].children.children.each do |child|
      if child.name == 'i'
        next
      else
        rule_text += text_digester(child)
      end
      rule_text += "\n"
    end
    rule_text
  end

  def rules_text
    rules_text = ""
    line.children[3].children.children.search('i').children.each do |child|
      rules_text += text_digester(child)
    end
    rules_text
  end

  def text_digester(element)
    if element["alt"]
      cost_digester(element["alt"])
    else
      element.text
    end
  end
end
