class TagsController < ApplicationController

  def show
    update = Updater.new
    update.tags
    @user = User.first
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @tags = ActsAsTaggableOn::Tag.all
    @textfiles = Textfile.tagged_with(@tag.name)
  end

  def destroy
    @user = User.first
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @tag.destroy
    flash.notice = "Tag '#{@tag.name.titleize}' deleted."
    redirect_to user_path(@user)
  end

  def edit
    # Why does it feel like I'm abusing global variables
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @textfiles = Textfile.all
    @user = User.first
  end

  def update
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @user = User.first
    @textfiles = Textfile.all

    # Add/remove tag from textfiles where applicable
    @textfiles.each do |tf|
      # If value returned, textfile is tagged. If nil, not tagged.
      tagged = !params[tf.id.to_s].nil?
      if tagged
        tf.tag_list.add(@tag.name)
      else
        tf.tag_list.remove(@tag.name)
      end
      tf.save
    end
    flash.notice = "Tag '#{@tag.name.titleize}' updated."
    @tag.reload
    unless @tag.taggings_count == 0
      redirect_to tag_path(@tag)
    else
      redirect_to user_path(@user)
    end
  end

  def rename
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end

  def do_rename
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    # Key "@tag.name" corresponds to value that is the new (or same) name
    @tag.name = params[@tag.name]
    @tag.save
    @tag.reload
    flash.notice = "Tag renamed to '#{@tag.name.titleize}'."
    redirect_to :back
  end

end
