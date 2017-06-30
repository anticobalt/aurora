# Exists because an error is thrown when I try to create tag.rb file under app/models.
# Maybe I'll try to find out excatly what's wrong later, but it's probably
# => because of the way ActsAsTaggableOn is implemented.

class TagPseudomodel
  # Returns a tag, or false if none found
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
      tagged = !params[tf.id.to_s].nil? # If value returned, textfile tagged. If nil, not tagged.
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

      # If category exists, add the new tag to it
      if existing_categ
        existing_categ[:tags] << params[:tag_name]

      # Otherwise create new category with new tag
      else
        user.tag_categories << {name: params[:category_name], tags: [params[:tag_name]]}
      end

    end
    tag.save && tag.reload && user.save && user.reload
  end

  # Updates properties of old tag
  def self.update_properties(params, tag, user)
    # Get old tag category from old tag name
    tag_category = user.tag_categories.find {|category| category[:tags].include? tag.name}

    # If category of tag was changed in form
    if tag_category[:name] != params[:category_name]
      # Add new tag name to new category
      user.tag_categories << {name: params[:category_name], tags: [params[:tag_name]]}
      # Remove old tag name from old category and delete old category if needed
      tag_category[:tags].delete(tag.name)
      user.tag_categories.delete(tag_category) if tag_category[:tags].empty?

    # If name (but not category) was changed
    elsif not tag_category.include? params[:tag_name]
      # Remove old name and add new name
      tag_category[:tags].delete(tag.name)
      tag_category[:tags] << params[:tag_name]
    end

    # Update tag's name
    tag.name = params[:tag_name]
    tag.save && tag.reload && user.save && user.reload
  end
end
