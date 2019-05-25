defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, data)

    IO.inspect(self())
    IO.puts("and im out from store")
  end

  def get(key) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)

    IO.inspect(self())
    IO.puts("and im out from get")
  end

  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, start_workers()}
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _from, workers) do
    worker_key = :erlang.phash2(key, 3)

    {:reply, Map.get(workers, worker_key), workers}
  end

  defp start_workers do
    for index <- 1..3, into: %{} do
      {:ok, pid} = Todo.DatabaseWorker.start(@db_folder)
      {index - 1, pid}
    end
  end

  # my little version
  #def start_workers do
  #  0..2
  #  |> Enum.reduce(%{}, fn i, acc ->
  #    {:ok, pid} = Todo.DatabaseWorker.start(@db_folder)
  #    Map.put(acc, i, pid)
  #  end)
  #end

end
