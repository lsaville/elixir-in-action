pid = ServerProcess.start(KeyValueStore)
ServerProcess.call(pid, {:put, :some_key, :some_value})
ServerProcess.call(pid, {:get, :some_key})

pid = KeyValueStore.start()
KeyValueStore.put(pid, :some_key, :some_value)
KeyValueStore.get(pid, :some_key)

pid = TodoServer.start()
TodoServer.add_entry(pid, %{date: ~D[2018-12-19], title: "Dentist"})
TodoServer.add_entry(pid, %{date: ~D[2018-12-20], title: "Shopping"})
TodoServer.add_entry(pid, %{date: ~D[2018-12-19], title: "Movies"})
TodoServer.delete_entry(pid, 1)
TodoServer.update_entry(pid, %{id: 2, date: ~D[2018-12-19], title: "WOW shopping"})
TodoServer.update_entry(pid, 3, &Map.put(&1, :title, "WOW movies"))
TodoServer.entries(pid, ~D[2018-12-19])

defmodule KeyValueStore do
  use GenServer

  def init(_) do
    :timer.send_interval(5000, :cleanup)
    {:ok, %{}}
  end

  def handle_info(:cleanup, state) do
    IO.puts "performing cleanup...."
    {:noreply, state}
  end
end
{:ok, pid} = GenServer.start(KeyValueStore, nil)

defmodule EchoServer do
  use GenServer

  @impl GenServer
  def handle_call(some_request, server_state) do
    {:reply, some_request, server_state}
  end
end
{:ok, pid} = GenServer.start(EchoServer, nil)
GenServer.call(pid, :some_call)


# todo_server w/GenServer
{:ok, pid} = TodoServer.start()
TodoServer.add_entry(pid, %{date: ~D[2018-12-19], title: "Dentist"})
TodoServer.add_entry(pid, %{date: ~D[2018-12-20], title: "Shopping"})
TodoServer.add_entry(pid, %{date: ~D[2018-12-19], title: "Movies"})
TodoServer.entries(pid, ~D[2018-12-19])
TodoServer.entries(pid)
TodoServer.delete_entry(pid, 1)
TodoServer.update_entry(pid, %{id: 2, date: ~D[2018-12-19], title: "WOW shopping"})
TodoServer.update_entry(pid, 3, &Map.put(&1, :title, "WOW movies"))
TodoServer.entries(pid, ~D[2018-12-19])
