defmodule ListHelper do
  def sum(list) do
    do_sum(0, list)
  end

  defp do_sum(current_sum, []), do: current_sum
  defp do_sum(current_sum, [head | tail]) do
    do_sum(current_sum + head, tail)
  end

  def sum_no_tail([]), do: 0
  def sum_no_tail([h | t]) do
    h + sum_no_tail(t)
  end

  def list_len(list) do
    do_list_len(0, list)
  end

  defp do_list_len(sum, []), do: sum
  defp do_list_len(sum, [_h | t]) do
    do_list_len(sum + 1, t)
  end

  def list_len_no_tail([]), do: 0
  def list_len_no_tail([_h | t]) do
    1 + list_len_no_tail(t)
  end

  def range(low, high) do
    do_range([], low, high)
  end

  defp do_range(acc, low, low), do: [low | acc]
  defp do_range(acc, low, high) do
    do_range([high | acc], low, high - 1)
  end

  def range_no_tail(high, high), do: [high]
  def range_no_tail(low, high) do
    [low | range_no_tail(low + 1, high)]
  end

  def positive(list) do
    do_positive([], list)
  end

  defp do_positive(acc, []), do: acc
  defp do_positive(acc, [h | t]) when h >= 0 do
    do_positive([h | acc], t)
  end
  defp do_positive(acc, [h | t]) when h < 0 do
    do_positive(acc, t)
  end

  def positive_no_tail([]), do: []
  def positive_no_tail([h | t]) when h >= 0 do
    [h | positive_no_tail(t)]
  end
  def positive_no_tail([h | t]) when h < 0 do
    positive_no_tail(t)
  end

  def reverse([]), do: []
  def reverse([h | t]) do
    append(reverse(t), [h])
  end

  def rev(list), do: rev_iter(list, [])
  def rev_iter([], acc), do: acc
  def rev_iter([h | t], acc) do
    rev_iter(t, [h | acc])
  end

  def append([], list2) do
    list2
  end
  def append([h | t], list2) do
    [h | append(t, list2)]
  end

end
