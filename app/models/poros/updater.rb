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
    textfiles_in_directory = []
    textfiles_possibly_modified = []
    textfiles_lost = []

    # Generate all model instances from local files
    directory = User.first.home
    paths = Scanner.new.all_file_paths(directory, "txt")
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
    potentially_changed = self.predict_modifications(textfiles_possibly_modified, textfiles_lost)
    textfiles_lost.each do |tf|
      tf.destroy unless potentially_changed.any? {|hash| hash[:old_file] == tf}
    end
    return potentially_changed
  end

  def tags
    ActsAsTaggableOn::Tag.all.each do |tag|
      if tag.taggings_count == 0
        tag.destroy
      end
    end
  end

  def predict_modifications(new, old)
    file = StringConstructor.new
    potentially_renamed = []
    potentially_moved = []

    old.each do |old_tf|
      folder = file.parent_directory(old_tf.location)
      # Predict file movements (higher priority)
      if new.any? { |new_tf|
        new_tf.name == old_tf.name }
      then
        potentially_moved << {old_file: old_tf}
        potentially_moved[-1][:type] = "moved"
        potentially_moved[-1][:new_files] = new.select {|new_tf| new_tf.name == old_tf.name}
      # Predict file renames
      elsif new.any? { |new_tf|
        folder == file.parent_directory(new_tf.location)}
      then
        # Create hashes with old file
        # => and associated new files that might be the old file but modified
        potentially_renamed << {old_file: old_tf}
        potentially_renamed[-1][:type] = "renamed"
        potentially_renamed[-1][:new_files] = new.select {|tf| file.parent_directory(tf.location) == folder}
      end
    end

    return potentially_renamed + potentially_moved
  end

end
