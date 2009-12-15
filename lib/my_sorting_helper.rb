## my_sorting_helper.rb,v 1.1 2006-05-30 K. Adam Christensen
# Added better documentation
# Added support for columns to be either an <tt>Array</tt> or <tt>Hash</tt>
module MySortingHelper
  
  class Sorter
    
    attr_accessor :page, :max_per_page
    attr_reader :sort, :criteria, :order, :filterfield, :columns, :filter, :per_page
    
    ORDER_OPTIONS = %w{ ASC DESC }
    CRITERIA_OPTIONS =  %w{ begin contain }
    
    ######################################
    # Set up our sorter.
    # * <tt>params</tt> - the params for page, per_page, order, sort, ...
    # * <tt>columns</tt> - the columns that can be sorted.  This can be an <tt>Array</tt> or a <tt>Hash</tt> where the key is the name of the <tt>params[:sort]</tt> or <tt>params[:filterfield]</tt>, and the value is what appears in the sql select.
    # * <tt>per_page</tt> - the number of records to display per page.  default: 20
    # * <tt>page</tt> - the page number to display.  default: 1
    def initialize(params, columns, per_page=20, page=1, max_per_page=50, default_sort=nil, default_order=nil)
      # Convert a Hash to a multi-dimensional array.  [ "key", value ]
      columns = columns.inject([]) { |o,(k,v)| o << [ k.to_s, v ] } if columns.is_a? Hash
      @default_sort = default_sort
      @default_order = default_order
      
      @columns          = columns
      @page             = params[:page]        ||= page
      @page = @page.to_i
      @max_per_page     = max_per_page
      self.per_page     = params[:per_page]    ||= per_page
      self.order        = params[:order]
      self.sort         = params[:sort]
      self.criteria     = params[:criteria]
      self.filterfield  = params[:filterfield]
      self.filter       = params[:filter]
    end
    
    ######################################
    # Mutator: sort
    # Makes sure that the sorting column is a member of one of the @columns.
    # If not, it's the first element in the @columns
    def sort=(new_sort)
      if @columns[0].is_a? Array
        matching_element = @columns.detect { |x| x[0] == new_sort }
        @sort = matching_element ? new_sort : (@default_sort || @columns[0][0])
      else
        @sort = @columns.include?(new_sort) ? new_sort : (@default_sort || @columns[0])
      end
    end
    
    ######################################
    # Mutator: per_page
    # Set the number of results per page
    # Make sure that the total pages returned doesn't excede the max.
    def per_page=(new_per_page)
      new_per_page = new_per_page.to_i
      if new_per_page > @max_per_page
        @per_page = @max_per_page
      else
        @per_page = new_per_page
      end
    end
    
    ######################################
    # Mutator: order
    # Makes sure that the order is ASC or DESC before setting it.
    # If not, defaults to ASC
    def order=(new_order)
      @order = ORDER_OPTIONS.include?(new_order) ? new_order : (@default_order || ORDER_OPTIONS[0])
    end
    
    ######################################
    # Mutator: criteria
    # Makes sure that the criteria is begin or contain before setting it.  
    # If not, defaults to begin.
    def criteria=(new_criteria)
      @criteria = CRITERIA_OPTIONS.include?(new_criteria) ? new_criteria : CRITERIA_OPTIONS[0] 
    end
    
    ######################################
    # Mutator: filterfield
    # Makes sure that the filter field is one of the acceptable columns before setting it.
    # If not, defaults to the first element in @columns
    def filterfield=(new_filterfield)
      if @columns[0].is_a? Array
        matching_element = @columns.detect { |x| x[0] == new_filterfield }
        @filterfield = matching_element ? new_filterfield : @columns[0][0]
      else
        @filterfield = @columns.include?(new_filterfield) ? new_filterfield : @columns[0]
      end
    end
    
    ######################################
    # Mutator: filter
    # If the passed in filter is nil, set the filterfield to nil.  
    # If there is no filter text, then there doesn't need to be a filterfield.
    def filter=(new_filter)
      self.filterfield = nil unless new_filter
      @filter = new_filter
    end
    
    ######################################
    # Returns a <tt>Hash</tt> or the sorting parameters merged with any other parameters for a link.
    def link_params(column_to_sort, params={})
      if column_to_sort == @sort
        order = ('ASC' == @order ? 'DESC' : 'ASC')
      else
        order = @order
      end
    
      my_params = Hash.new
      my_params[:sort] = column_to_sort == nil ? @sort : column_to_sort
      my_params[:order] = order
      
      my_params.merge(params)
    end #def link_params
  
    ######################################
    # Returns a <tt>Hash</tt> of parameters for a <tt>ActiveRecord::Base#find</tt>
    # It merges the parameters used for the <tt>#find</tt> with those for the sorting.
    # TODO: Make sure that the conditions merge together in a union and don't overwrite each other.
    def sql_params(params={})
      my_params = Hash.new
      my_params[:order] = sort_param
      #my_params[:limit] = self.per_page
      #my_params[:offset] = (self.per_page * self.page) - self.per_page
      #my_params[:per_page] = @per_page.to_i
      if @filter
        if @criteria == 'begin'
          tmp_filter = "#{@filter}%"
        else
          tmp_filter = "%#{@filter}%"
        end
        my_params[:conditions] = [ "#{get_value_for_sql(@filterfield)} LIKE ?", tmp_filter ]
      end
    
      my_params.merge(params)
    end #def sql_params
    
    ######################################
    def sort_param
      "#{get_value_for_sql(@sort)} #{@order}"
    end
    
    ######################################
    private
    ######################################
    
    ######################################
    # Returns the value of either the filter field or the sorting column
    def get_value_for_sql(column)
      if @columns.is_a? Array
        tmp = @columns.detect { |x| x[0] == column }
        tmp[1]
      else
        column
      end
    end #def get_value_for_sql
    
  end
end