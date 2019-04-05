defmodule NumHelper do
  def sum_nums(enumerable) do
    Enum.reduce(enumerable, 0, &maybe_add_num/2)
  end

  defp maybe_add_num(num, sum) when is_number(num), do: sum + num
  defp maybe_add_num(_, sum), do: sum
end
