class UsersController < ApplicationController
  include UsersHelper

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
    # Essentially the index for Textfile and Tag
    @user = User.find(params[:id])
    @textfiles = Textfile.in_home.by_join_date
    @tags = ActsAsTaggableOn::Tag.all
    # Changes is an array of hashes
    changes = ModelInstanceRefresher.everything
    unless changes.empty?
      # @user.data should be an empty array, but to be foolproof...
      @user.data = []
      changes.each { |change| @user.data << change }
      # ... and is now an array of hashes (which each have an array)
      @user.save
      @no_scroll = true
      render "view_file_changes_for"
    else
      render "show"
    end
  end

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

  def show_untagged
    @user = User.find(params[:id])
    @textfiles = Textfile.all.select{|t| t.tag_list.empty?}
    @tags = ActsAsTaggableOn::Tag.all
  end

end

# User.delete_all
# ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'users'")
