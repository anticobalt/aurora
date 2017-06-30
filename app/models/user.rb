# The User model's only purpose is to remember app preferences
# => in the form of Strings and stuff

class User < ApplicationRecord
  # data is for holding temporary values
  serialize :data, Array
  serialize :tag_categories, Array
  validate :directory_valid?
  before_save :remove_extra_slashes, :fix_folder_cases

  def directory_valid?
    if self.home == ""
      errors.add("Missing field:", "Home directory not entered.")
    # Blank home directory is invalid, and satisfies the below condition,
    # but Rails can't work with an empty string as the message key
    elsif not Dir.exists? self.home
      errors.add(self.home, "is an invalid directory.")
    end
  end

  # model_instance_updater.rb already adds slashes between filename and parent directory
  # => when constructing file location strings, so trailing slashes are redundant.
  # Remove them if user adds them.
  # Also, if user decides to add 20 forward slashes, remove them.
  def remove_extra_slashes
    self.home = StringConstructor.sanitized_filepath self.home
  end

  # Windows only
  def fix_folder_cases
    self.home = DiskScanner.real_filepath self.home
  end
end
