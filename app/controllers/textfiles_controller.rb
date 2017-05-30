class TextfilesController < ApplicationController
  include TextfilesHelper

  def show
    update = Updater.new
    update.tags
    @user = User.first
    @tags = ActsAsTaggableOn::Tag.all
    @textfile = Textfile.find(params[:id])
  end

  def edit
    @user = User.first
    @textfile = Textfile.find(params[:id])
  end

  def update
    @textfile = Textfile.find(params[:id])
    save = ModelInstanceUpdater.new
    save.textfile_from_form(@textfile, textfile_params)
    flash.notice = "File '#{@textfile.name}' updated."
    redirect_to textfile_path(@textfile)
  end

end
