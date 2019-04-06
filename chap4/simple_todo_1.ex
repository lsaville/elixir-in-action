defmodule TodoList do
  def new(), do: %{}

  def add_entry(todo_list, date, title) do
    Map.update(
      todo_list,
      date,
      [title],
      fn titles -> [title | titles] end
    )
  end
end

# from example usage p.105
todo_list =
  TodoList.new()
  |> TodoList.add_entry(~D[2018-12-19], "Dentist")
  |> TodoList.add_entry(~D[2018-12-20], "Shopping")
  |> TodoList.add_entry(~D[2018-12-19], "Movies")

IO.inspect(todo_list)
