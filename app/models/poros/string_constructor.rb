class StringConstructor

  def parent_directory(abs_path)
    # E.g. "C:\\windows\\log.txt" => "C:\\windows"
    child = abs_path.split("\\")[-1]
    span = abs_path.length - child.length - 2 # Constant to remove trailing slashes
    abs_path[0..span]
  end

end
