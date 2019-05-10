defmodule TodoServer do
  def start do
    spawn(fn ->
      loop(TodoList.new())
    end)
  end

  def entries(server_pid, date) do
    send(server_pid, {:entries, date, self()})

    receive do
      {:response, entries} ->
        IO.inspect(entries)
    after
      5000 -> {:error, :timeout}
    end
  end

  def add_entry(server_pid, entry) do
    send(server_pid, {:add_entry, entry})
  end

  defp loop(current_list) do
    new_list =
      receive do
        message -> process_message(current_list, message)
      end

    loop(new_list)
  end

  defp process_message(todo_list, {:entries, date, caller}) do
    send(caller, {:response, TodoList.entries(todo_list, date)})
    todo_list
  end
  defp process_message(todo_list, {:add_entry, entry}) do
    TodoList.add_entry(todo_list, entry)
  end
  defp process_message(todo_list, invalid) do
    IO.puts("#{invalid} not supported")
  end
end

defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(), do: %TodoList{}

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
