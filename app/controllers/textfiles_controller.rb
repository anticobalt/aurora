class TextfilesController < ApplicationController
  include TextfilesHelper

  def index

    # Generate all model instances from local files
    directory = User.first.home
    paths = Scanner.new.all_file_paths directory, "txt"
    create_or_update = Updater.new
    textfiles_in_directory = []
    paths.each do |path|
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

  def edit
    @textfile = Textfile.find(params[:id])
  end

  def update

    # Remember old name and update name and contents
    @textfile = Textfile.find(params[:id])
    old_name = @textfile.name
    @textfile.update(textfile_params)

    # Update location
    construct = StringConstructor.new
    pd = construct.parent_directory @textfile.location
    @textfile.location = pd + "\\" + @textfile.name
    @textfile.save

    # Update the local file
    write_to_associated_file = Writer.new
    write_to_associated_file.textfile(@textfile.location, old_name)

    # Finish up
    flash.notice = "File #{@textfile.name} updated."
    redirect_to textfile_path(@textfile)

  end

end
