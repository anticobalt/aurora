# Methods: new/create*, show, edit*/change_tagged/change_properties, destroy

# *tags can be created through TagController#create or by appending to
# => Textfile's tag_list and letting gem do the rest.
# *edit has two POST counterparts that do different things but exist on same view.

class TagsController < ApplicationController

  def new
    # Don't need @tag to create a tag
    # As tags can be created by appending to Textfile's tag_list
    @textfiles = Textfile.all
    @user = User.first
  end

  def create
    @user = User.first
    @textfiles = Textfile.all
    if params["tag_name"] == ""
      flash.notice = "Missing tag name."
      redirect_to new_tag_path
    # Checks if numeric keys exist.
    # Numeric keys are model instance ids, so are non-zero. It's a hack.
    elsif params.keys.none? {|key| key.to_i.to_s == key}
      flash.notice = "No files selected."
      redirect_to new_tag_path
    else
      tag = TagPseudomodel.tag_with_name params["tag_name"]
      if tag
        flash.notice = "Tag already exists. Added tagged files to existing tag."
        # Save must be after tag_with_name check
        TagPseudomodel.save_taggings(params, params["tag_name"], @textfiles)
      else
        TagPseudomodel.save_taggings(params, params["tag_name"], @textfiles)
        tag = ActsAsTaggableOn::Tag.find_by(name: params["tag_name"])
        TagPseudomodel.create_properties(params, tag, @user)
        flash.notice = "Tag '#{tag.name}' created."
      end
      redirect_to tag_path(tag)
    end
  end

  def show
    ModelInstanceRefresher.tags
    @user = User.first
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @tags = ActsAsTaggableOn::Tag.all
    @textfiles = Textfile.tagged_with(@tag.name)
  end

  def edit
    # Why does it feel like I'm abusing global variables
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @textfiles = Textfile.all
    @user = User.first
    @category = @user.tag_categories.find {|c| c[:tags].include? @tag.name}
  end

  def change_tagged
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @user = User.first
    @textfiles = Textfile.all
    TagPseudomodel.save_taggings(params, @tag.name, @textfiles, prevent_remove = false)
    flash.notice = "Tag '#{@tag.name}' updated."
    unless @tag.taggings_count == 0
      redirect_to tag_path(@tag)
    else
      redirect_to user_path(@user)
    end
  end

  def change_properties
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @user = User.first
    tag_with_same_name = TagPseudomodel.tag_with_name params["tag_name"]
    if tag_with_same_name and tag_with_same_name.id != @tag.id
      flash.notice = "Tag name '#{params["tag_name"]}' in use by another tag"
    else
      TagPseudomodel.update_properties(params, @tag, @user)
      flash.notice = "Properties saved."
    end
    redirect_to :back
  end

  def destroy
    @user = User.first
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @tag.destroy
    tag_category = @user.tag_categories.find {|category| category[:tags].include? @tag.name}
    tag_category[:tags].delete(@tag.name)
    @user.tag_categories.delete(tag_category) if tag_category[:tags].empty?
    @user.save
    flash.notice = "Tag '#{@tag.name}' deleted."
    redirect_to user_path(@user)
  end

end
