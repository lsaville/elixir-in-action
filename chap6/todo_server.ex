defmodule TodoServer do
  use GenServer

  @impl true
  def init(_) do
    {:ok, TodoList.new()}
  end

  def start do
    GenServer.start(TodoServer, nil)
  end

  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add_entry, entry})
  end

  def update_entry(pid, entry) do
    GenServer.cast(pid, {:update_entry, entry})
  end
  def update_entry(pid, entry_id, updater_fun) do
    GenServer.cast(pid, {:update_entry, entry_id, updater_fun})
  end

  def delete_entry(pid, entry_id) do
    GenServer.cast(pid, {:delete_entry, entry_id})
  end

  def entries(pid) do
    GenServer.call(pid, {:entries})
  end
  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  @impl true
  def handle_cast({:add_entry, entry}, todo_list) do
    {:noreply, TodoList.add_entry(todo_list, entry)}
  end

  @impl true
  def handle_cast({:update_entry, entry}, todo_list) do
    {:noreply, TodoList.update_entry(todo_list, entry)}
  end

  @impl true
  def handle_cast({:update_entry, entry_id, updater_fun}, todo_list) do
    {:noreply, TodoList.update_entry(todo_list, entry_id, updater_fun)}
  end

  @impl true
  def handle_cast({:delete_entry, entry_id}, todo_list) do
    {:noreply, TodoList.delete_entry(todo_list, entry_id)}
  end

  @impl true
  def handle_call({:entries, date}, _from, todo_list) do
    {:reply, TodoList.entries(todo_list, date), todo_list}
  end

  @impl true
  def handle_call({:entries}, _from, todo_list) do
    {:reply, TodoList.entries(todo_list), todo_list}
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

  def entries(todo_list) do
    todo_list.entries
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end
end
