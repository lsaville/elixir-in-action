#Can't be registered by name
defmodule Todo.DatabaseWorker do
  use GenServer

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder)
  end

  def store(worker, {:store, key, value}) do
    GenServer.cast(worker, {:store, key, value})
  end

  def get(worker, {:get, key, caller}) do
    GenServer.call(worker, {:get, key, caller})
  end

  @impl GenServer
  def init(db_folder) do
    File.mkdir_p!(db_folder)
    {:ok, db_folder}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, state) do
    IO.puts("=========== from:")
    IO.inspect(self())
    IO.inspect("storing #{key}")

    key
    |> file_name(state)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:get, key, caller}, _from, state) do
    IO.puts("=========== from:")
    IO.inspect(self())
    IO.inspect("getting data for #{key}")

    data = case File.read(file_name(key, state)) do
      {:ok, contents} -> :erlang.binary_to_term(contents)
      _ -> nil
    end

    GenServer.reply(caller, data)

    {:reply, state}
  end

  defp file_name(key, db_folder) do
    Path.join(db_folder, to_string(key))
  end

end
