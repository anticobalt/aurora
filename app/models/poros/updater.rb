# Check given file for associated Model instance,
# => and if one doesn't exist, create it

class Updater

  def textfile(abs_path)
    tf = Textfile.find_by(location: abs_path)
    if tf.nil?
      tf = Textfile.new
      # Filepath's directory levels are seperated by "\" (see scanner.rb)
      tf.name = abs_path.split("\\")[-1]
      tf.location = abs_path
    end
    File.open(abs_path, "r") do |f|
      tf.contents = f.readlines.join("")
    end
    tf.save
    return tf
  end

end
