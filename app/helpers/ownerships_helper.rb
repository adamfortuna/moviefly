module OwnershipsHelper
  
  def fields_for_ownership(ownership, &block)
    prefix = ownership.new_record? ? 'new' : 'existing'
    fields_for("ownerships[#{prefix}_viewship_attributes][]", ownership, &block)
  end

  def add_ownership_link(name) 
    link_to_function name do |page| 
      page.insert_html :bottom, :ownerships, :partial => 'user_ownerships/form', :object => Ownership.new 
    end 
  end
end