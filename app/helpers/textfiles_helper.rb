module TextfilesHelper
  def textfile_params
    params.require(:textfile).permit(:name, :contents, :location, :tag_list)
  end
end
