# Write (to) files based on edit forms
# May involve renaming files

class Writer

  def textfile(new_abs_path, old_name)

      tf = Textfile.find_by(location: new_abs_path)
      new_name = new_abs_path.split("\\")[-1]
      construct = StringConstructor.new
      pd = construct.parent_directory tf.location

      File.rename(pd + "\\" + old_name, new_abs_path) unless new_name == old_name
      File.open(new_abs_path, "w") do |f|
        # tf.contents has the correct number of CRLF characters,
        # => but the output file of f.write(tf.contents) has twice as many.
        # I think f.write() is treating \r and \n as two seperate newline characters
        # => causing the output file to have 2x the number of required CRLF characters.
        # Interestingly, Notepad seems to display the file with the
        # => right number of newlines, while Notepad++ does not.
        # i.e I have no idea wtf is wrong, but this hack fixes it
        # => (for Notepad++ on Windows).
        f.write(tf.contents.gsub("\r\n", "\n"))
      end

  end

end
