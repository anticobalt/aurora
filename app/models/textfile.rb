class Textfile < ApplicationRecord
  acts_as_taggable
  scope :by_join_date, -> {order("created_at DESC")} # Scope has to be a block
  scope :in_home, -> {where(archived: false)}

  before_validation :cache
  validate :name_legal?, :name_not_in_use?
  before_save :set_category_for_new_tags, :write_to_disk

  def form_data=(params)
    @params = params
  end

  def cache
    @old_location = self.location if @params
  end

  # Check for invalid characters (part 1)
  def name_legal?
    if @params
      if self.name.include?("\\") or self.name.include?("/")
        errors.add("Invalid name:", "Slashes not allowed in names.")
      elsif self.name == ""
        errors.add("Invalid name:", "No name provided.")
      end
    end
  end

  def name_not_in_use?
    # Why in the world is *every* validation required to fail before save can be cancelled?
    # If some of the data is already invalid, I don't think saving is a good idea.
    if @params and errors.empty?
      # Adjust the name so that it can be checked
      new_parent_directory = User.first.home + "\\" + @params[:textfile][:location_partial]
      self.location = StringConstructor.sanitized_filepath(new_parent_directory + "\\" + self.name)
      self.location = DiskScanner.real_filepath(self.location)
      self.name = self.location.split("\\")[-1] # Name now also real_filepath'd

      # Check if file already exists in that location
      same_name_tf = Textfile.find_by(location: self.location)
      unless same_name_tf.nil? or same_name_tf == self
        errors.add(self.location, "already exists. Choose another name.")
      end
    end
  end

  # If new tags are created through form, add them to "Unorganized"
  def set_category_for_new_tags
    if @params
      self.tag_list.each do |tag|
        unless TagPseudomodel.tag_with_name tag
          user = User.first # Using User.first.tag_categories.find{} doesn't update the user
          unorganized = user.tag_categories.find {|c| c[:name] == "Unorganized"}
          unorganized[:tags] << tag
          user.save
        end
      end
    end
  end

  # Check for invalid characters (part 2)
  def write_to_disk
    if @params and errors.empty?
      unless DiskWriter.save_textfile(@old_location, self.location, self.contents)
        errors.add("Write to disk failed:", "check for invalid characters in '#{self.location}'")
        throw(:abort)
      end
    end
  end
end
