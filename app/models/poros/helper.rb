# Collection of methods only called by other POROs, not controllers

class Helper
  # Given a list of old and new textfiles, predicts which "new" could simply be
  # => the old ones renamed/moved
  def self.predict_modifications(new, old)
    potentially_renamed = []
    potentially_moved = []
    old.each do |old_tf|
      folder = StringConstructor.parent_directory(old_tf.location)

      # Predict file movements (higher priority)
      if new.any? { |new_tf|
        new_tf.name == old_tf.name }
      then
        potentially_moved << {old_file: old_tf}
        potentially_moved[-1][:type] = "moved"
        potentially_moved[-1][:new_files] = new.select {|new_tf| new_tf.name == old_tf.name}

      # Predict file renames
      elsif new.any? { |new_tf|
        folder == StringConstructor.parent_directory(new_tf.location)}
      then
        # Create hashes with old file
        # => and associated new files that might be the old file but modified
        potentially_renamed << {old_file: old_tf}
        potentially_renamed[-1][:type] = "renamed"
        potentially_renamed[-1][:new_files] = new.select {|tf| StringConstructor.parent_directory(tf.location) == folder}
      end

    end
    return potentially_renamed + potentially_moved
  end

end
