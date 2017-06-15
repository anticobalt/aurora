# Write (to) files based on edit forms
# May involve renaming/deleting files

class Writer

  def textfile(new_abs_path, old_abs_path)
      new_name = new_abs_path.split("\\")[-1]
      old_name = old_abs_path.split("\\")[-1]
      construct = StringConstructor.new
      new_pd = construct.parent_directory new_abs_path
      old_pd = construct.parent_directory old_abs_path

      if new_pd != old_pd
        # Instead of moving, delete and recreate
        File.delete(old_abs_path)
      elsif new_name != old_name
        File.rename(pd + "\\" + old_name, new_abs_path)
      end

      tf = Textfile.find_by(location: new_abs_path)
      Dir.mkdir new_pd unless File.exists? new_pd
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
