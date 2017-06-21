module UsersHelper
  def user_params
    params.require(:user).permit(:home, :data, :textfile_display_mode, :tag_categories)
  end
end
