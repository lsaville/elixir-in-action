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
    #choose_worker
    GenServer.cast(__MODULE__, {:store, key, data})
  end

  def get(key) do
    #choose_worker
    GenServer.call(__MODULE__, {:get, key})
  end


  def choose_worker(key) do
    #same worker for same key
  end


  #REST
  @impl GenServer
  def init(_) do
    #start workers and store them in a map
    #0 based index keys
    File.mkdir_p!(@db_folder)
    {:ok, nil}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, state) do
    #send to worker
    key
    |> file_name()
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:get, key}, _from, state) do
    #send to worker
    data = case File.read(file_name(key)) do
      {:ok, contents} -> :erlang.binary_to_term(contents)
      _ -> nil
    end

    {:reply, data, state}
  end

  defp file_name(key) do
    Path.join(@db_folder, to_string(key))
  end

end
