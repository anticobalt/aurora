    @textfiles = Textfile.in_home.by_join_date
    @user.tag_categories << {name: "Unorganized", tags:[]}
  # With this, if user moves/renames files outside of app (e.g. in the OS filesystem)
  # => tags can be migrated from old to new file model instances

  def show_untagged
    @user = User.find(params[:id])
    @textfiles = Textfile.all.select{|t| t.tag_list.empty?}
    @tags = ActsAsTaggableOn::Tag.all
  end
