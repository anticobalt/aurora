class StringConstructor

  def parent_directory(abs_path)
    # E.g. "C:\\windows\\log.txt" => "C:\\windows"
    child = abs_path.split("\\")[-1]
    span = abs_path.length - child.length - 2 # Constant to remove trailing slashes
    abs_path[0..span]
  end

  def snippet(text)
    begin
      lines = text.split("\n")
    rescue ArgumentError
      return "ERROR: invalid characters found in file. Ensure that the file is encoded in UTF-8."
    end

    if text.length < 1000 and lines.length < 20
      return text
    else
      # If text is long despite not having a lot of lines
      if text.scan(/.{1,70}/).length > lines.length
        return text[0...20*70] + (text[20*70..-1].split("\n")[0]).to_s
      # If text is short character-wise but has a lot of lines
      elsif lines.length >= 20
        return lines[0..20].join("\n")
      end
    end
  end

end
