# chap 7 mix proj
{:ok, pid} = Todo.Server.start()
Todo.Server.add_entry(pid, %{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.add_entry(pid, %{date: ~D[2018-12-20], title: "Shopping"})
Todo.Server.add_entry(pid, %{date: ~D[2018-12-19], title: "Movies"})
Todo.Server.entries(pid, ~D[2018-12-19])
Todo.Server.entries(pid)
Todo.Server.delete_entry(pid, 1)
Todo.Server.update_entry(pid, %{id: 2, date: ~D[2018-12-19], title: "WOW shopping"})
Todo.Server.update_entry(pid, 3, &Map.put(&1, :title, "WOW movies"))
Todo.Server.entries(pid, ~D[2018-12-19])

#cache
{:ok, cache} = Todo.Cache.start()
Todo.Cache.server_process(cache, "Bob's list")
bobs_list = Todo.Cache.server_process(cache, "Bob's list")
Todo.Cache.server_process(cache, "Alice's list")

Todo.Server.add_entry(bobs_list, %{date: ~D[2018-12-19], title: "Dentist"})
Todo.Server.entries(bobs_list)

Todo.Cache.server_process(cache, "Alice's list") |>
  Todo.Server.entries(~D[2018-12-19])

#many lists
{:ok, cache} = Todo.Cache.start()
:erlang.system_info(:process_count)
Enum.each(
  1..100_000,
  fn index ->
    Todo.Cache.server_process(cache, "to-do list #{index}")
  end
)
:erlang.system_info(:process_count)
