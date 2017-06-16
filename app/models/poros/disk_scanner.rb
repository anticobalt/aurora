# Reads and checks directories/files
require 'pathname'

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

  # Windows only
  def self.real_filepath(path)
    # Assumes path is sanitized
    levels = path.split("\\")
    case_corrected_path = ""
    # Drive root is always uppercase
    case_corrected_path << levels[0].upcase + "\\"
    levels_corrected = 1

    # Check each level for case insensitive folder name match,
    # => building corrected path name. If some levels don't exist yet, just make them
    found = true # Assume folder exists
    until levels.length == levels_corrected
      # If directories from here on are new
      unless found
        case_corrected_path << levels[levels_corrected] + "\\"
        levels_corrected += 1
        next
      end
      # Dir.entries requires path have "\\", otherwise it defaults to working directory
      Dir.entries(case_corrected_path).each do |obj|
        if obj.casecmp(levels[levels_corrected]) == 0
          case_corrected_path << obj + "\\"
          levels_corrected += 1
          found = true
          break
        end
        # If existing loop without finding anything that matches, this is set
        # Signals that new folders need to be created, so scanning not required
        found = false
      end
    end

    # last character is "\\", which is redundant
    return case_corrected_path[0...-1]
  end

end
