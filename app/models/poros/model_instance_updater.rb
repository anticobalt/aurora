# Load and saves model instances

class ModelInstanceUpdater

  # Unable to discern brand new files from files that have been moved/renamed
  def self.textfile_from_file(abs_path)
    # Force directory path name to be lowercase because Windows is case-insensitive
    name = abs_path.split("\\")[-1]
    tf = Textfile.find_by(location: abs_path)
    if tf.nil?
      tf = Textfile.new
      # Filepath's directory levels are seperated by "\" (see disk_scanner.rb)
      tf.name = name
      tf.location = abs_path
      tf.tag_list.add("new")
      new = true
    else
      new = false
    end
    File.open(abs_path, "r") do |f|
      tf.contents = f.readlines.join("")
    end
    # Updating means it's automatically no longer archived
    tf.archived = false
    tf.save
    return [tf, new]
  end

  def self.textfile_from_form(textfile, textfile_params, new_parent_directory)
    # Check that name has no slashes
    if textfile_params[:name].include?("\\") or textfile_params[:name].include?("/")
      return false
    end
    # Remember old location/name (the two attributes that might be invalid)
    old_location = textfile.location
    old_name = textfile.name
    # Blanket update all attributes
    textfile.update(textfile_params)
    # Fix name and location, update, save
    textfile.location = StringConstructor.sanitized_filepath(new_parent_directory + "\\" + textfile.name)
    textfile.location = DiskScanner.real_filepath(textfile.location)
    textfile.name = textfile.location.split("\\")[-1] # Name now also real_filepath'd
    textfile.save
    # Update the local file
    unless DiskWriter.textfile(textfile.location, old_location)
      # Revert name and location if the write failed, as textfile is now corrupt
      # Note that contents do NOT revert
      textfile.name = old_name
      textfile.location = old_location
      textfile.save
      false
    else
      true
    end
  end

  # Uses form data to check if tag transfers set by user are valid,
  # => valid being that multiple old files aren't being pointed to same new file.
  # If valid, do the transfer. If not, return false.
  def self.transfer_tags(form_data)
    # Parse the raw form data
    transfers = {}
    form_data.each do |key, value|
      # if key is a natural number (i.e. represents a model instance ID)
      if key.to_i.to_s == key
        transfers[key] = value
      end
    end
    # Verify that form was filled completely by user
    if transfers.length == 0 then return false end
    # Check for duplicate targets
    seen = []
    transfers.each do |key, value|
      if seen.include? value and value != "none"
        return false
      else
        seen << value
      end
    end
    # Do tag transfer, and delete old model instances
    transfers.each do |key, value|
      source = Textfile.find(key)
      unless value == "none"
        target = Textfile.find(value)
        target.tag_list = source.tag_list
        target.save
      end
      source.destroy
    end
    return true
  end

end
