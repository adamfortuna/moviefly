class Specification
  def and(specification)
    And.new([self, specification])
  end
  
  def not
    Not.new(self)
  end
  
  # No bind values by default.
  def bind_values
    []
  end
  
  # No joins by default.
  def joins
    []
  end
  
  def conditions
    [statement, *bind_values]
  end
  
  def finder_options
    {:conditions => conditions, :joins => joins.join(' ')}
  end
  
  private
  def initialize(options)
    @options = options
  end
end

class Not < Specification
  def statement
    "NOT (#{@specification.statement})"
  end
  
  def bind_values
    @specification.bind_values
  end
  
  def description
    @specification.negative_description
  end
  
  def negative_description
    @specification.description
  end
  
  def joins
    @specification.joins
  end
  
  private
  
  def initialize(specification)
    @specification = specification
  end
end

class And < Specification
  def statement
    @specifications.collect { |spec| "(#{spec.statement})" }.join(' AND ')
  end
  
  def bind_values
    @specifications.inject([]) { |vals, spec| vals += spec.bind_values }
  end
  
  def description
    @specifications.collect { |spec| spec.description }.join(' and ')
  end
  
  def negative_description
    @specifications.collect { |spec| spec.negative_description }.join(' or ')
  end
  
  def joins
    @specifications.collect { |spec| spec.joins }.flatten.compact
  end
  
  private
  
  def initialize(specifications)
    @specifications = specifications
  end
end

require "filters"