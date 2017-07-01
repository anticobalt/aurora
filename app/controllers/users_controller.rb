# Methods: new/create, index*, show*, show_untagged, edit/update,
# => view_file_changes_for/verify_file_changes_for, export, import

# *index decides whether to create new user or show the existing user.
# *show either displays all textfiles and tags, or displays popup prompting user
# => to verify file changes if required.

class UsersController < ApplicationController
  include UsersHelper

  def new
    @user = User.new
    @no_scroll = true
  end

  def create
    @user = User.new(user_params)
    @user.tag_categories << {name: "Unorganized", tags:[]}
    if @user.save
      flash.notice = "Preferences saved."
      redirect_to user_path(@user)
    else
      flash.notice = @user.errors.full_messages[0]
      redirect_to new_user_path
    end
  end

  def index
    # Only one user exists at a time
    @users = User.all
    if @users.length == 1
      redirect_to user_path(User.first)
    else
      redirect_to new_user_path
    end
  end

  # Decides if file verification or default show is rendered
  def show
    @user = User.first # instead of User.find(params[:id]), to handle importing new user
    @textfiles = Textfile.in_home.by_join_date
    @tags = ActsAsTaggableOn::Tag.all
    changes = ModelInstanceRefresher.everything # Changes is an array of hashes
    @user = User.first # user attributes may have changed due to previous call
    unless changes.empty?
      @user.data = [] # ensure @user.data is empty
      changes.each { |change| @user.data << change } # data is array of hashes of arrays
      @user.save
      @no_scroll = true
      render "view_file_changes_for"
    else
      render "show"
    end
  end

  def show_untagged
    @user = User.find(params[:id])
    @textfiles = Textfile.all.select{|t| t.tag_list.empty?}
    @tags = ActsAsTaggableOn::Tag.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash.notice = "Saved."
      redirect_back(fallback_location: user_path(@user))
    else
      flash.notice = @user.errors.full_messages[0]
      redirect_back(fallback_location: user_path(@user))
    end
  end

  def view_file_changes_for
    @user = User.find(params[:id])
    @no_scroll = true
  end

  # With this, if user moves/renames files outside of app (e.g. in the OS filesystem)
  # => tags can be migrated from old to new file model instances
  def verify_file_changes_for
    @user = User.find(params[:id])
    if ModelInstanceUpdater.transfer_tags params
      flash.notice = "Files were successfully updated."
      @user.data = []
      @user.save
      redirect_to user_path(@user)
    else
      flash.notice = "Invalid operation: attempted to transfer multiple files' data to one file " +
      "OR did not designate target for some files (make sure all pages are filled out)."
      redirect_to view_file_changes_for_user_path(@user)
    end
  end

  def export
    @user = User.find(params[:id])
    @tags = ActsAsTaggableOn::Tag.all
    @textfiles = Textfile.all
    if DiskWriter.export_user_data(@user, @textfiles)
      flash.notice = "User data was exported with time stamp."
    else
      flash.notice = "Export failed."
    end
    redirect_back(fallback_location: users_path)
  end

  def import
    @user = User.find(params[:id])
    flash.notice = ModelInstanceUpdater.user_data_from_import @user
    redirect_back(fallback_location: users_path)
  end

end
