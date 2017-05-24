class Updater

  def everything
    self.home
    self.tags
  end

  def home
    # Generate all model instances from local files
    directory = User.first.home
    paths = Scanner.new.all_file_paths(directory, "txt")
    create_or_update = ModelInstanceUpdater.new
    textfiles_in_directory = []

    paths.each do |path|
      textfile = create_or_update.textfile_from_file path
      textfiles_in_directory << textfile
    end

    # Remove old Textfiles that are not longer in user's designated directory
    Textfile.all.each do |tf|
      unless textfiles_in_directory.include? tf
        tf.destroy
      end
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
