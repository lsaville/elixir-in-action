#Can't be registered by name
defmodule Todo.DatabaseWorker do
  use GenServer

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder)
  end

  @impl GenServer
  def init(db_folder) do
    File.mkdir_p!(db_folder)
    {:ok, db_folder}
  end


  def store(key, data) do
    GenServer.cast(__MODULE__, {:store, key, data})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  @impl GenServer
  def handle_cast({:store, key, data}, state) do
    key
    |> file_name(state)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, data, state}
  end

  @impl GenServer
  def handle_call({:get, key}, _from, state) do
    data = case File.read(file_name(key, state)) do
      {:ok, contents} -> :erlang.binary_to_term(contents)
      _ -> nil
    end

    {:reply, data, state}
  end

  defp file_name(key, db_folder) do
    Path.join(db_folder, to_string(key))
  end

end
