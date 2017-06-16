# Reads and checks directories/files

class DiskScanner

  # Finds files of a certain type/file-extension in all subdirectories, recursively
  def self.all_file_paths(directory, extension=nil)
    files = []
    Dir.entries(directory).each do |obj|
      # Generate object's absolute path
      # Dir uses "\" to seperate directory levels, so I did the same
      abs_path_obj = directory + "\\" + obj
      # If object is a folder but not "." or "..", run scanner recursively
      if File.directory? abs_path_obj and not [".",".."].include? obj
        files = files + self.all_file_paths(abs_path_obj, extension=extension)
      # Else if object is a file
      elsif File.file? abs_path_obj
        unless extension and not obj.include? extension
          files << abs_path_obj
        end
      end
    end
    return files
  end

end
