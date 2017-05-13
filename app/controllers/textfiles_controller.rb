class TextfilesController < ApplicationController
  include TextfilesHelper

  def index
    directory = User.first.home
    paths = Scanner.new.all_file_paths directory, "txt"
    create_or_update = Updater.new
    textfiles_in_directory = []
    paths.each do |path|
      # Based on my limited experience with RSpec (well, Ruby in general, really)
      # => and its interesting method-naming conventions,
      # => I get the feeling this naming style is idiomatic Ruby
      textfile = create_or_update.textfile path
      textfiles_in_directory << textfile
    end
    # Remove old Textfiles that are not longer in user's designated directory
    Textfile.all.each do |tf|
      unless textfiles_in_directory.include? tf
        tf.destroy
      end
    end
    # Index view renders as soon as @textfile is initialized,
    # => so this line has to be last
    @textfiles = Textfile.all
  end

  def show
    @textfile = Textfile.find(params[:id])
  end

end
