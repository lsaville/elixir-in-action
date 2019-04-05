defmodule NaturalNums do
  def print(1), do: IO.puts(1)
  def print(n) do
    print(n-1) #recursion before the print, hits
               #bottom and prints 'on the way out'
    IO.puts(n)
  end
end
