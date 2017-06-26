# Write (to) files based on edit forms
# Involves renaming/deleting/creating files

require 'fileutils'
require 'json'

class DiskWriter

  def self.save_textfile(old_abs_path, new_abs_path, contents)
    unless self.change_path(old_abs_path, new_abs_path)
      return false
    end
    unless self.write_textfile(new_abs_path, contents)
      return false
    end
    return true
  end

  # Rename or move*; false only if error, true otherwise
  def self.change_path(old_abs_path, new_abs_path)
    new_name = new_abs_path.split("\\")[-1]
    new_pd = StringConstructor.parent_directory new_abs_path
    unless old_abs_path.nil?
      old_name = old_abs_path.split("\\")[-1]
      old_pd = StringConstructor.parent_directory old_abs_path
      if new_pd != old_pd
        # *Instead of moving, delete and recreate
        File.delete(old_abs_path)
      elsif new_name != old_name
        begin
          File.rename(old_abs_path, new_abs_path)
          return true
        rescue Errno::EINVAL
          return false
        end
      else
        return true
      end
    else
      return true
    end
  end

  def self.write_textfile(path, contents)
    begin
      new_pd = StringConstructor.parent_directory path
      FileUtils::mkdir_p new_pd unless Dir.exists? new_pd
      File.open(path, "w") do |f|
        # tf.contents has the correct number of CRLF characters,
        # => but the output file of f.write(tf.contents) has twice as many.
        # I think f.write() is treating \r and \n as two seperate newline characters
        # => causing the output file to have 2x the number of required CRLF characters.
        # Interestingly, Notepad seems to display the file with the
        # => right number of newlines, while Notepad++ does not.
        # i.e I have no idea wtf is wrong, but this hack fixes it
        # => (for Notepad++ on Windows).
        contents.gsub!("\r\n", "\n")
        f.write(contents)
      end
      return true
    rescue Errno::EINVAL
      return false
    end
  end

  def self.delete(path)
    if File.exist?(path)
      FileUtils.rm(path)
      true
    else
      false
    end
  end

  def self.export_user_data(user, textfiles)
    hash = {
      user: {
        home: user.home,
        textfile_dm: user.textfile_display_mode,
        categories: user.tag_categories
      },
      textfiles: []
    }
    textfiles.each do |tf|
      hash[:textfiles] << {location: tf.location, tags: tf.tag_list, archived: tf.archived}
    end
    folder = user.home + "\\json-exports\\"
    file = folder + Time.now.strftime("%Y%m%d%H%M%S") + ".json"
    FileUtils::mkdir_p folder unless Dir.exists? folder
    File.open(file, "w") do |f|
      f.write(JSON.pretty_generate(hash))
    end
    return true
  end

end
