module ViewsHelper
  
  def fields_for_viewship(viewship, &block)
    prefix = viewship.new_record? ? 'new' : 'existing'
    fields_for("view[#{prefix}_viewship_attributes][]", viewship, &block)
  end

  def add_viewship_link(name, id) 
    link_to_function name do |page| 
      page.insert_html :bottom, "viewships_#{id}", :partial => 'viewships/viewship', :object => Viewship.new 
    end 
  end

  def add_view_link(name) 
    link_to_function name do |page| 
      page.insert_html :bottom, :views, :partial => 'form', :object => Viewship.new(:view => View.new, :user => current_user )
    end 
  end
  
  def view_details(view, separator = " ")
    v = []
    v << "On #{view.on}." unless view.on.nil?
    v << "Location #{view.location}" unless view.location.blank?
    v << "Attendees: #{users_list(view.viewships.collect(&:user))}"
    v << "<p>Notes: #{view.notes}</p>" unless view.notes.blank?
    v.join(separator)
  end
  
  def users_list(users)
    users.collect { |u| link_to u.login, user_path(u) }.join(", ")
  end
end