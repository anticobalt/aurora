module UsersHelper
  def user_params
    params.require(:user).permit(:home)
  end
end
