# Load and saves model instances

class ModelInstanceUpdater

  # Unable to discern brand new files from files that have been moved/renamed
  def textfile_from_file(abs_path)
    tf = Textfile.find_by(location: abs_path)
    if tf.nil?
      tf = Textfile.new
      # Filepath's directory levels are seperated by "\" (see scanner.rb)
      tf.name = abs_path.split("\\")[-1]
      tf.location = abs_path
      tf.tag_list.add("new")
      new = true
    else
      new = false
    end
    File.open(abs_path, "r") do |f|
      tf.contents = f.readlines.join("")
    end
    tf.save
    return [tf, new]
  end

  def textfile_from_form(textfile, textfile_params)
    # Remember old name and update name and contents
    old_name = textfile.name
    textfile.update(textfile_params)
    # Update location
    construct = StringConstructor.new
    pd = construct.parent_directory textfile.location
    textfile.location = pd + "\\" + textfile.name
    textfile.save
    # Update the local file
    write_to_associated_file = Writer.new
    write_to_associated_file.textfile(textfile.location, old_name)
  end

  # Uses form data to check if tag transfers set by user are valid,
  # => valid being that multiple old files aren't being pointed to same new file.
  # If valid, do the transfer. If not, return false.
  def tag_transfer(form_data)
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
