  # Decides if file verification or default show is rendered
    @textfiles = Textfile.by_join_date
    update = Updater.new
    # Changes is an array of hashes
    changes = update.everything
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
    @no_scroll = true
      redirect_back(fallback_location: user_path(@user))
      redirect_back(fallback_location: user_path(@user))
  def view_file_changes_for
    @user = User.find(params[:id])
    @no_scroll = true
  end

# With this, if user moves/renames files outside of app (e.g. in the OS filesystem)
# => tags can be migrated from old to new file model instances
  def verify_file_changes_for
    @user = User.find(params[:id])
    perform = ModelInstanceUpdater.new
    if perform.tag_transfer params
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