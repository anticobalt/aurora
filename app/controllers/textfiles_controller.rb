class TextfilesController < ApplicationController
  include TextfilesHelper

  def show
    update = Updater.new
    update.tags
    @user = User.first
    @tags = ActsAsTaggableOn::Tag.all
    @textfile = Textfile.find(params[:id])
    # If true, contents closely resemble original txt file's formatting
    if @user.textfile_display_mode == "wysiwyg"
      @wysiwyg = true
    elsif @user.textfile_display_mode == "alternative"
      @wysiwyg = false
    end
  end

  def edit
    @user = User.first
    @textfile = Textfile.find(params[:id])
    create = StringConstructor.new
    @relative_dir = create.relative_directory(@textfile.location, @user.home)
  end

  def update
    @textfile = Textfile.find(params[:id])
    @user = User.first
    pd = @user.home + "\\" + params[:textfile][:location_partial]
    save = ModelInstanceUpdater.new
    save.textfile_from_form(@textfile, textfile_params, pd)
    flash.notice = "File '#{@textfile.name}' updated."
    redirect_to textfile_path(@textfile)
  end

end
