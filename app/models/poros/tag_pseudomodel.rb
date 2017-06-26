# Because an error is thrown when I try to create tag.rb file under app/models.
# Maybe I'll try to find out excatly what's wrong later, but it's probably
# => because of the way ActsAsTaggableOn is implemented.

class TagPseudomodel

  # Return a tag, or false if none found
  def self.tag_with_name(name)
    tag = ActsAsTaggableOn::Tag.all.find { |t| t.name.casecmp(name) == 0 }
    if tag.nil?
      false
    else
      tag
    end
  end

  def self.save_taggings(params, tag_name, textfiles, prevent_remove=true)
    textfiles.each do |tf|
      # If value returned, textfile is tagged. If nil, not tagged.
      tagged = !params[tf.id.to_s].nil?
      if tagged
        tf.tag_list.add(tag_name)
      elsif prevent_remove == false
        tf.tag_list.remove(tag_name)
      end
      tf.save && tf.reload
    end
  end

  # Defines properties of brand new tag
  def self.create_properties(params, tag, user)
    if params[:category_name] == ""
      unorganized = user.tag_categories.find{|c| c[:name] == "Unorganized"}
      unorganized[:tags] << params[:tag_name]
    else
      existing_categ = user.tag_categories.find {|c| c[:name] == params[:category_name]}
      if existing_categ # if category exists, add the new tag to it
        existing_categ[:tags] << params[:tag_name]
      else # otherwise create new category with new tag
        user.tag_categories << {name: params[:category_name], tags: [params[:tag_name]]}
      end
    end
    tag.save && tag.reload && user.save && user.reload
  end

  # Updates properties of old tag
  def self.update_properties(params, tag, user)
    # Get old tag category from old tag name
    tag_category = user.tag_categories.find {|category| category[:tags].include? tag.name}
    if tag_category[:name] != params[:category_name] # if category of tag was changed in form
      # Add new tag name to new category
      user.tag_categories << {name: params[:category_name], tags: [params[:tag_name]]}
      # Remove old tag name from old category and delete old category if needed
      tag_category[:tags].delete(tag.name)
      user.tag_categories.delete(tag_category) if tag_category[:tags].empty?
    elsif not tag_category.include? params[:tag_name] # if name (but not category) was changed
      # Remove old name and add new name
      tag_category[:tags].delete(tag.name)
      tag_category[:tags] << params[:tag_name]
    end
    # Update tag's name
    tag.name = params[:tag_name]
    tag.save && tag.reload && user.save && user.reload
  end

end
