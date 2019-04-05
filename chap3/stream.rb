class Stream
  def initialize(collection)
    @collection = collection
    @funs = []
  end

  def map(fun)
    @@funs << fun
  end

  def go
    @collection.reduce([]) do |acc, elem|
      acc << @funs.reduce do |acc2, fun|
      end
    end
  end
end
