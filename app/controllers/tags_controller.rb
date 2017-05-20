class TagsController < ApplicationController

  def show
    @user = User.first
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @textfiles = Textfile.tagged_with(@tag.name)
  end

end
