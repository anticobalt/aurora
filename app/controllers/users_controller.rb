class UsersController < ApplicationController
  include UsersHelper

  def index
    # Only one user exists at a time
    @users = User.all
    if @users.length == 1
      redirect_to textfiles_path
    else
      redirect_to new_user_path
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash.notice = "Preferences saved."
      redirect_to textfiles_path
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
      redirect_to textfiles_path
    else
      flash.notice = @user.errors.full_messages[0]
      redirect_to edit_user_path
    end
  end

end

# User.delete_all
# ActiveRecord::Base.connection.execute("DELETE from sqlite_sequence where name = 'users'")
