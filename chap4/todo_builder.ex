
defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    # fn -> style
    #
    #Enum.reduce(
    #  entries,
    #  %TodoList{},
    #  fn entry, todo_list_acc ->
    #    add_entry(todo_list_acc, entry)
    #  end
    #)
    Enum.reduce(
      entries,
      %TodoList{},
      &add_entry(&2, &1)
    )
  end

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)

    new_entries = Map.put(
      todo_list.entries,
      todo_list.auto_id,
      entry
    )

    %TodoList{todo_list |
      entries: new_entries,
      auto_id: todo_list.auto_id + 1
    }
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list
      {:ok, old_entry} ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def update_entry(todo_list, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end

  def delete_entry(todo_list, entry_id) do
    %TodoList{todo_list | entries: Map.delete(todo_list.entries, entry_id)}
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end
end


defmodule TodoList.CsvImporter do
  def import(file_path) do
    File.stream!(file_path)
    |> Stream.map(&(String.replace(&1, "\n", "")))
    |> Stream.map(&(String.split(&1, ",")))
    |> Stream.map(fn [date, title] ->
      %{date: date, title: title}
    end)
    |> Enum.to_list
    |> TodoList.new()
  end
end

#Iex fodder

todo_list =
  TodoList.new() |>
  TodoList.add_entry(%{date: ~D[2018-12-19], title: "Dentist"}) |>
  TodoList.add_entry(%{date: ~D[2018-12-20], title: "Shopping"}) |>
  TodoList.add_entry(%{date: ~D[2018-12-19], title: "Movies"})

todo_list_from_list = TodoList.new([
  %{date: ~D[2018-12-19], title: "Dentist"},
  %{date: ~D[2018-12-20], title: "Shopping"},
  %{date: ~D[2018-12-19], title: "Movies"}
])

TodoList.entries(todo_list, ~D[2018-12-19])
