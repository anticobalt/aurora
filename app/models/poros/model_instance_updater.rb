# Load and saves model instances

class ModelInstanceUpdater

  # Unable to discern brand new files from files that have been moved/renamed
  def self.textfile_from_file(abs_path)
    tf = Textfile.find_by(location: abs_path)
    if tf.nil?
      tf = Textfile.new
      # Filepath's directory levels are seperated by "\" (see disk_scanner.rb)
      tf.name = abs_path.split("\\")[-1]
      tf.location = abs_path
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

  def self.user_data_from_import(user)
    folder = user.home + "\\json-exports\\"
    if Dir.exists? folder
      jsons = Dir.entries(folder).sort
      unless jsons.empty?
        to_load = jsons[-1] # get most recent export
        hash = JSON.parse File.read(folder + to_load) # key by string, not symbol
        Destroyer.everything
        self.user_from_hash(hash['user']) # also creates categories
        self.textfiles_from_hash(hash['textfiles']) # also creates tags
        return "Data successfully imported."
      else
        return "There is no data for this home directory (no data to import from #{folder})."
      end
    else
      return "There is no data for this home directory (#{folder} doesn't exist)."
    end
  end

  def self.user_from_hash(hash)
    user = User.new
    user.home = hash['home']
    user.textfile_display_mode = hash['textfile_dm']
    user.tag_categories = []
    hash['categories'].each do |category|
      user.tag_categories << category.symbolize_keys
    end
    user.save
  end

  def self.textfiles_from_hash(array)
    array.each do |hash|
      tf = Textfile.new
      tf.location = hash['location']
      tf.name = tf.location.split("\\")[-1]
      tf.archived = hash['archived']
      tf.tag_list = hash['tags']
      File.open(tf.location, "r") do |f|
        tf.contents = f.readlines.join("")
      end
      tf.save
    end
  end

end
