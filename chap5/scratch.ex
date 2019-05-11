run_query =
  fn query_def ->
    Process.sleep(2000)
    "#{query_def} result"
  end

Enum.map(1..5, &run_query.("query #{&1}"))

async_query =
  fn query_def ->
    spawn(fn -> IO.puts(run_query.(query_def)) end)
  end

Enum.each(1..5, &async_query.("query #{&1}"))

# synchronous sending
run_query =
  fn query_def ->
    Process.sleep(2000)
    "#{query_def} result"
  end

async_query =
  fn query_def ->
    caller = self()
    spawn(fn ->
      send(caller, {:query_result, run_query.(query_def)})
    end)
  end

get_result =
  fn ->
    receive do
      {:query_result, result} -> result
    end
  end

results = Enum.map(1..5, fn _ -> get_result.() end)

1..5 |>
Enum.map(&async_query.("query #{&1}")) |>
Enum.map(fn _ -> get_result.() end)


server_pid = DatabaseServer.start()
DatabaseServer.run_async(server_pid, "query 1")
DatabaseServer.get_result()
DatabaseServer.run_async(server_pid, "query 2")
DatabaseServer.get_result()

pool = Enum.map(1..100, fn _ -> DatabaseServer.start() end))

Enum.each(
  1..5,
  fn query_def ->
    server_pid = Enum.at(pool, :rand.uniform(100) - 1)
    DatabaseServer.run_async(server_pid, query_def)
  end
)

Enum.map(1..5, fn _ -> DatabaseServer.get_result() end)

# For Calculator
pid = Calculator.start()
Calculator.add(pid, 10)
Calculator.sub(pid, 5)
Calculator.mul(pid, 3)
Calculator.div(pid, 5)
Calculator.value(pid)

# For TodoServer
todo_server = TodoServer.start()
TodoServer.add_entry(todo_server, %{date: ~D[2018-12-19], title: "Dentist"})
TodoServer.add_entry(todo_server, %{date: ~D[2018-12-20], title: "Shopping"})
TodoServer.add_entry(todo_server, %{date: ~D[2018-12-19], title: "Movies"})
TodoServer.delete_entry(todo_server, 1)
TodoServer.update_entry(todo_server, %{id: 2, date: ~D[2018-12-19], title: "WOW shopping"})
TodoServer.update_entry(todo_server, 3, &Map.put(&1, :title, "WOW movies"))
TodoServer.entries(todo_server, ~D[2018-12-19])

# TodoServer with registered process
todo_server = TodoServer.start()
TodoServer.add_entry(%{date: ~D[2018-12-19], title: "Dentist"})
TodoServer.add_entry(%{date: ~D[2018-12-20], title: "Shopping"})
TodoServer.add_entry(%{date: ~D[2018-12-19], title: "Movies"})
TodoServer.delete_entry(1)
TodoServer.update_entry(%{id: 2, date: ~D[2018-12-19], title: "WOW shopping"})
TodoServer.update_entry(3, &Map.put(&1, :title, "WOW movies"))
TodoServer.entries(~D[2018-12-19])
