defmodule ServerProcess do
  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init()
      loop(callback_module, initial_state)
    end)
  end

  def cast(server_pid, request) do
    send(server_pid, {:cast, request})
  end

  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})

    receive do
      {:response, response} ->
        response
    end
  end

  defp loop(callback_module, current_state) do
    receive do
      {:call, request, caller} ->
        {response, new_state} =
          callback_module.handle_call(
            request,
            current_state
          )

        send(caller, {:response, response})

        loop(callback_module, new_state)

      {:cast, request} ->
        new_state =
          callback_module.handle_cast(
            request,
            current_state
          )

        loop(callback_module, new_state)
    end
  end
end

defmodule TodoServer do
  def init do
    Todolist.new()
  end

  def start do
    ServerProcess.start(TodoServer)
  end

  # examples from server_process_cast
  #def put(pid, key, value) do
  #  ServerProcess.cast(pid, {:put, key, value})
  #end
  #
  #def get(pid, key) do
  #  ServerProcess.call(pid, {:get, key})
  #end

  #MAIN INTERFACE
  #call
  def entries(date) do
    send(:todo_server, {:entries, date, self()})

    receive do
      {:todo_entries, entries} ->
        entries
    after
      5000 -> {:error, :timeout}
    end
  end

  def entries(pid, date) do
    ServerProcess.call(pid, {:entries, date})
  end

  #cast
  def add_entry(pid, entry) do
    ServerProcess.cast(pid, {:add_entry, entry})
  end

  #cast
  def update_entry(pid, %{} = entry) do
    ServerProcess.cast(pid, {:update_entry, entry})
  end
  #cast
  def update_entry(pid, entry_id, updater_fun) do
    ServerProcess.cast(pid, {:update_entry, entry, updater_fun})
  end

  #cast
  def delete_entry(pid, entry_id) do
    ServerProcess.cast(pid, {:delete_entry, entry_id})
  end
  #END MAIN INTERFACE

  #HANDLES
  defp handle_call(todo_list, {:entries, date, caller}) do
    send(caller, {:todo_entries, TodoList.entries(todo_list, date)})
    todo_list
  end
  defp handle_cast(todo_list, {:add_entry, entry}) do
    TodoList.add_entry(todo_list, entry)
  end
  defp handle_cast(todo_list, {:update_entry, %{} = entry}) do
    TodoList.update_entry(todo_list, entry)
  end
  defp handle_cast(todo_list, {:update_entry, entry_id, updater_fun}) do
    TodoList.update_entry(todo_list, entry_id, updater_fun)
  end
  defp handle_cast(todo_list, {:delete_entry, entry_id}) do
    TodoList.delete_entry(todo_list, entry_id)
  end
  defp handle_cast(_todo_list, invalid) do
    IO.puts("#{invalid} not supported")
  end
  #END HANDLES
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
