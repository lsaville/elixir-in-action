defmodule MyModule do
  alias IO, as: MyIO
  #import IO

  def my_function do
    MyIO.puts "Calling imported function"
  end
end
