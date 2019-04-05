defmodule Circle do
  @moduledoc "Implements basic circle functions"
  @pi 3.141576

  @doc "Computes the area of a circle"
  @spec area(number) :: number
  def area(r), do: r*r*@pi

  @doc "Computes the circumference of a circle"
  @spec circumference(number) :: number
  def circumference(r), do: 2*@pi*r
end
