# Write (to) files based on edit forms
# Involves renaming/deleting/creating files

require 'fileutils'

class Writer

  def textfile(new_abs_path, old_abs_path=nil)
    construct = StringConstructor.new
    file = Scanner.new
    # Duplicate used for argument because the original is frozen/immutable
    new_name = new_abs_path.split("\\")[-1]
    new_pd = construct.parent_directory new_abs_path

    unless old_abs_path.nil?
      old_name = old_abs_path.split("\\")[-1]
      old_pd = construct.parent_directory old_abs_path
      if new_pd != old_pd
        # Instead of moving, delete and recreate
        File.delete(old_abs_path)
      elsif new_name != old_name
        begin
          File.rename(old_abs_path, new_abs_path)
        rescue Errno::EINVAL
          return false
        end
      end
    end

    tf = Textfile.find_by(location: new_abs_path)
    begin
      FileUtils::mkdir_p new_pd unless File.exists? new_pd
      File.open(new_abs_path, "w") do |f|
        # tf.contents has the correct number of CRLF characters,
        # => but the output file of f.write(tf.contents) has twice as many.
        # I think f.write() is treating \r and \n as two seperate newline characters
        # => causing the output file to have 2x the number of required CRLF characters.
        # Interestingly, Notepad seems to display the file with the
        # => right number of newlines, while Notepad++ does not.
        # i.e I have no idea wtf is wrong, but this hack fixes it
        # => (for Notepad++ on Windows).
        contents = tf.contents.gsub("\r\n", "\n")
        f.write(contents)
      end
      true
    rescue Errno::EINVAL
      false
    end

  end

end
