module TextfilesHelper
  def textfile_params
    params.require(:textfile).permit(:name, :contents, :location, :embedded_id)
  end
end
