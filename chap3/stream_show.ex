defmodule StreamShow do
  defp filter_newlines!(path) do
    path
    |> File.Stream!()
    |> Stream.map(&String.replace(&1, "\n", ""))
  end

  def lines_length!(path) do
    path
    |> filter_newlines!()
    |> Stream.map(&String.length(&1))
    |> Enum.to_list
  end

  def longest_lines_length!(path) do
    path
    |> filter_newlines!()
    |> Stream.map(&String.length(&1))
    |> Enum.max
  end

  def longest_line!(path) do
    path
    |> filter_newlines!()
    |> Stream.map(&({String.length(&1), &1}))
    |> Enum.max
  end

  def words_per_line!(path) do
    path
    |> filter_newlines!()
    |> Stream.map(&length(String.split(&1)))
    |> Enum.to_list
  end
end
