# Refreshes stuff

class Updater

  def everything
    changes = self.home
    self.tags
    return changes
  end

  def home
    # Setup
    create_or_update = ModelInstanceUpdater.new
    local = Scanner.new
    from_changes = Helper.new
    textfiles_in_directory = []
    textfiles_possibly_modified = []
    textfiles_lost = []

    # Generate all model instances from local files
    directory = User.first.home
    paths = local.all_file_paths(directory, "txt")
    paths.each do |path|
      data = create_or_update.textfile_from_file path
      textfile = data[0]
      new = data[1]
      textfiles_in_directory << textfile
      if new
        textfiles_possibly_modified << textfile
      end
    end

    # Track old Textfiles that are not longer in user's designated directory
    Textfile.all.each do |tf|
      unless textfiles_in_directory.include? tf
        textfiles_lost << tf
      end
    end
    # If there are new files found, get potentially changed and selectively delete old files;
    # => otherwise, just delete everything that's old
    unless textfiles_possibly_modified.empty?
      potentially_changed = from_changes.predict_modifications(textfiles_possibly_modified, textfiles_lost)
      textfiles_lost.each do |tf|
        tf.destroy unless potentially_changed.any? {|hash| hash[:old_file] == tf}
      end
      return potentially_changed
    else
      textfiles_lost.each do |tf|
        tf.destroy
      end
      return []
    end
  end

  def tags
    ActsAsTaggableOn::Tag.all.each do |tag|
      if tag.taggings_count == 0
        tag.destroy
      end
    end
  end

end
