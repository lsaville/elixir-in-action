defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"

  #INTERFACE
  def start do
    GenServer.start(__MODULE__, nil,
      name: __MODULE__
    )
  end

  def store(key, data) do
    choose_worker(key)
    |> Todo.DatabaseWorker.store({:store, key, data})
    IO.puts("and im out from store")
  end

  def get(key) do
    choose_worker(key)
    |> Todo.DatabaseWorker.get({:get, key, self()})
    IO.puts("and im out from get")
  end


  def choose_worker(key) do
    GenServer.call(__MODULE__, {:worker, key})
  end

  def create_workers do
    0..2
    |> Enum.reduce(%{}, fn i, acc ->
      {:ok, pid} = Todo.DatabaseWorker.start(@db_folder)
      Map.put(acc, i, pid)
    end)
  end

  #REST
  @impl GenServer
  def init(_) do
    workers = create_workers()
    {:ok, workers}
  end

  #@impl GenServer
  #def handle_cast({:store, key, data}, state) do
  #  #send to worker
  #  key
  #  |> file_name()
  #  |> File.write!(:erlang.term_to_binary(data))

  #  {:noreply, state}
  #end

  #@impl GenServer
  #def handle_call({:get, key}, _from, state) do
  #  #send to worker
  #  data = case File.read(file_name(key)) do
  #    {:ok, contents} -> :erlang.binary_to_term(contents)
  #    _ -> nil
  #  end

  #  {:reply, data, state}
  #end

  @impl GenServer
  def handle_call({:worker, key}, _from, state) do
    access_key = :erlang.phash2(key, 3)

    {:reply, Map.get(state, access_key), state}
  end

  #defp file_name(key) do
  #  Path.join(@db_folder, to_string(key))
  #end

end
