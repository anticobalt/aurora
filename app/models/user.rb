# The User model's only purpose is to remember app preferences
# => in the form of Strings and stuff

class User < ApplicationRecord
  validate :directory_valid?
  before_save :remove_trailing_slash

  def directory_valid?
    if self.home == ""
      errors.add("Missing field:", "Home directory not entered.")
    # Blank home directory is invalid, and satisfies the below condition,
    # but Rails can't work with an empty string as the message key
    elsif not Scanner.new.directory_valid? self.home
      errors.add(self.home, "is an invalid directory.")
    end
  end

  # model_instance_updater.rb already adds slashes between filename and parent directory
  # => when constructing file location strings, so trailing slashes are redundant
  # Remove them if user adds them
  def remove_trailing_slash
    if self.home[-1] == "\\"
      self.home = self.home[0..-2]
    end
  end

end
