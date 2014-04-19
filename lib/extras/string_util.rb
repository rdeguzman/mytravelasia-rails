module StringUtil

  def self.remove_double_spaces(text)
    while text.include? "  "
      text = text.gsub("  ", " ")
    end

    return text.strip
  end

  def self.remove_last_sentence(text)
    text = text.strip

    if text.length > 0
      if text.include? "."
        a = text.split(".")

        if a.count > 1
          a.pop
          text = a.join(". ")
          text.strip
        end
      end

      if text[-1, 1] != "."
        text = text  + "."
      end
    end

    return text
  end

  def self.clean(text)
    #text.gsub(/\r\n?/, "").gsub(/^\s+/, "").gsub("\n", " ").gsub(/\s+$/, "").gsub(/\t/,"")
    return remove_double_spaces(text.gsub(/\r\n?/, "").gsub(/^\s+/, "").gsub("\n", " ").gsub(/\t/,"").strip)
  end

  def self.clean_commas(text)
    temp_text = []
    text.split(",").each do |element|
      temp_text.push(element.strip)
    end

    temp_text = temp_text.join(", ")
    temp_text = self.remove_double_spaces(temp_text)

    return temp_text
  end
end
