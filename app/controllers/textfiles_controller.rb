# Methods: new/create, show, edit/update, destroy

class TextfilesController < ApplicationController
  include TextfilesHelper

  def new
    @textfile = Textfile.new
    @user = User.first
    @relative_dir = ""
  end

  def create
    # Almost identical to update
    @textfile = Textfile.new(textfile_params)
    @textfile.form_data = params
    @user = User.first
    if @textfile.save
      flash.notice = "File '#{@textfile.name}' created."
      redirect_to textfile_path(@textfile)
    else
      flash.notice = @textfile.errors.full_messages[0]
      redirect_back(fallback_location: user_path(@user))
    end
  end

  def show
    ModelInstanceRefresher.tags
    @user = User.first
    @tags = ActsAsTaggableOn::Tag.all
    @textfile = Textfile.find(params[:id])
    if @user.textfile_display_mode == "wysiwyg"
      @wysiwyg = true
    elsif @user.textfile_display_mode == "alternative"
      @wysiwyg = false
    end
  end

  def edit
    @user = User.first
    @textfile = Textfile.find(params[:id])
    @relative_dir = StringConstructor.relative_directory(@textfile.location, @user.home)
  end

  def update
    @textfile = Textfile.find(params[:id])
    @textfile.form_data = params
    @user = User.first
    if @textfile.update(textfile_params)
      flash.notice = "File '#{@textfile.name}' updated."
      redirect_to textfile_path(@textfile)
    else
      # Save the contents to database anyways, to be more user-friendly
      @textfile.update_column('contents', params[:textfile][:contents])
      flash.notice = @textfile.errors.full_messages[0]
      redirect_back(fallback_location: textfile_path(@textfile))
    end
  end

  def destroy
    @textfile = Textfile.find(params[:id])
    @user = User.first
    @textfile.destroy
    if DiskWriter.delete(@textfile.location)
      flash.notice = "File '#{@textfile.name}' successfully deleted."
    else
      flash.notice = "#{@textfile.name} sucessfully removed from app, but not found on disk."
    end
    redirect_to user_path(@user)
  end

end
