class Year < Specification
  def statement
    "movies.year #{@options[:operand]} ?"
  end
  def bind_values
    [@options[:year]]
  end
  def description
    "year #{@options[:operand]} #{@options[:year]}"
  end
  def negative_description
    "year !#{@options[:operand]} #{@options[:year]}"
  end
end

class ImdbRating < Specification
  def statement
    "movies.imdb_rating #{@options[:operand]} ?"
  end
  def bind_values
    [@options[:rating]]
  end
  def description
    "imdb rating #{@options[:operand]} #{@options[:rating]}"
  end
  def negative_description
    "imdb rating !#{@options[:operand]} #{@options[:rating]}"
  end
  private
end

class Runtime < Specification
  def statement
    "movies.runtime #{@options[:operand]} ?"
  end
  def bind_values
    [@options[:runtime]]
  end
  def description
    "movie runtime #{@options[:operand]} #{@options[:runtime]}"
  end
  def negative_description
    "movie runtime !#{@options[:operand]} #{@options[:runtime]}"
  end
end
