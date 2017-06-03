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

  def show
    # Essentially the index for Textfile and Tag
    update = Updater.new
    update.everything
    @user = User.find(params[:id])
    @textfiles = Textfile.all
    @tags = ActsAsTaggableOn::Tag.all
  end

  def new
    @user = User.new
    @creating_user = true
  end

  def create
    @user = User.new(user_params)
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
      redirect_to user_path(@user)
    else
      flash.notice = @user.errors.full_messages[0]
      redirect_to edit_user_path(@user)
    end
  end

end

# User.delete_all
# ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'users'")
