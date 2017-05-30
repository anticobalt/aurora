class ModelInstanceUpdater

  def textfile_from_file(abs_path)
    tf = Textfile.find_by(location: abs_path)
    if tf.nil?
      tf = Textfile.new
      # Filepath's directory levels are seperated by "\" (see scanner.rb)
      tf.name = abs_path.split("\\")[-1]
      tf.location = abs_path
      tf.tag_list.add("new")
    end
    File.open(abs_path, "r") do |f|
      tf.contents = f.readlines.join("")
    end
    tf.save
    return tf
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

end
