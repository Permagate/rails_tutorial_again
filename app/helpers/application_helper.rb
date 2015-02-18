module ApplicationHelper

  def full_title(title = "")
    final_title = "Ruby on Rails Tutorial Sample App"
    if title.empty?
      final_title
    else
      "#{title} | #{final_title}"
    end
  end

end
