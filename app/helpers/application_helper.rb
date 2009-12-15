module ApplicationHelper
  extend ActiveSupport::Memoizable
  include JavascriptsHelper
  
  # Used in views to set the page title for the layout
  def title(page_title)
    @title = page_title
    content_for(:title) { page_title }
  end
  
  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, html_escape(flash[msg.to_sym]), :id => "flash-#{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end

  def body_class
    "#{request['controller']}-#{request['action']}"
  end
  
  # # wraps links_to_remote_sort with the per_page of the will_paginate collection
  # def paginate_sort(collection, column, text, url, options={})    
  #   link_to_sort(column, text, url.merge(params).merge(:per_page => collection.per_page), options)
  # rescue
  #   link_to_sort(column, text, url.merge(params), options)
  # end
  # 
  # # this acts exactly the same as link_to_sort but uses an link_to_remote
  # def link_to_sort(column, text, url, options={})
  #   link_to text, {:url => url.merge(@sorter.link_params(column.to_s).stringify_keys)}.merge(:method => :get), options
  # rescue
  #   link_to text, {:url => url}.merge(:method => :get), options
  # end
  
  def menu_link(text, link, options = {})
    options.reverse_merge! :a_class => [], :li_class => []

    # If there is only one option passed in, convert it to an array
    options[:li_class] = Array.new([options[:li_class]]) if options[:li_class].class == String
    #options[:li_class].push("current") if current_page?(link)
    options[:li_class].push("active") if request.path_info == link
    
    content_tag :li, menu_a(text,link, options), :class => options[:li_class].length > 0 ? options[:li_class].join(' ') : nil
  end
  
  def menu_a(text, link, options = {})
    options[:a_class] = Array.new([options[:a_class]]) if options[:a_class].class == String
    link_to text, link, { :class => options[:a_class].length > 0 ? options[:a_class].join(' ') : nil }
  end
  
  def direction_for(field)
    if params[:order] != field
      return "desc" if field.match(/count/) ||  field.match(/rating/)
      return "asc"
    end
    
    return (params[:direction] == "asc") ? "desc" : "asc" 
  end
  
  def column_class_for(field)
    return "" unless params[:order] == field
    direction = (params[:direction] == "asc") ? "asc" : "desc" 
    return " class=\"active #{direction}\""
  end
  memoize :column_class_for
  
  def current_rating_for(movie, type="one", zero = "0")
    current_user.rated?(movie, type) ? current_user.rating_for(movie, type).rating : zero
  end
  
  def rate_for(movie, type="one")    
    javascript_onload do
      "$('#movie_rating_#{movie.id}').slider('option', 'value', #{current_rating_for(movie, type)});"
    end

    content_tag :div, :class => "ratings_wrapper" do
      content_tag(:div, "", :id => "movie_rating_#{movie.id}", :class => "rating", "data-param" => movie.to_param) + content_tag(:span, current_rating_for(movie, type, "no rating"), :class => movie.to_param, :class => "rating_value")
    end
  end
  
  def has_ratings(element = "#content .rating")
    javascript_onload do
      "$('#{element}').slider({ slide: app.rating_changing, change: app.rating_change, step: #{current_user.rating_step} });"
    end
  end
  
  def inline_rating(element = "#content .rating")
    "<script language='text/javascript'>$('#{element}').slider({ slide: app.rating_changing, change: app.rating_change, step: #{current_user.rating_step} });</script>"
  end
  
  
  # def new_review_dialog_for(page, id, title, buttons)
  #   page[id].dialog({:width => 600,
  #                    :height => 400,
  #                    :title => title,
  #                    :modal => true,
  #                    :buttons => { "Create Review" => "function(){ alert('test');}" }
  #                   })
  # end
  
  def review_dialog_for(page, id, title, buttons)
    page[id].dialog({:width => 600,
                     :height => 400,
                     :title => title,
                     :modal => true,
                     :buttons => buttons
                    })
    
  end
end