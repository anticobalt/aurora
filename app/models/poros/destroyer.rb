# Only purpose as of now is for debugging

class Destroyer

  def self.everything
    ActsAsTaggableOn::Tag.destroy_all
    User.delete_all
    Textfile.delete_all
  end

end
