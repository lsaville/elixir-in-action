Todo.System.start_link()
Process.exit(Process.whereis(Todo.Database), :kill)
Process.exit(Process.whereis(Todo.Cache), :kill)

{:ok, _} = Registry.start_link(name: :my_registry, keys: :unique)

spawn(fn ->
  Registry.register(:my_registry, {:database_worker, 1}, nil)

  receive do
    msg -> IO.puts("got message #{inspect(msg)}")
  end
end)

[{db_worker_pid, _value}] =
  Registry.lookup(
    :my_registry,
    {:database_worker, 1}
  )


send(db_worker_pid, :some_message)
Registry.lookup(:my_registry, {:database_worker, 1})


# from the docs for lookup
Registry.start_link(keys: :unique, name: Registry.UniqueLookupTest)

Registry.lookup(Registry.UniqueLookupTest, "hello")

{:ok, _} = Registry.register(Registry.UniqueLookupTest, "hello", :world)

Registry.lookup(Registry.UniqueLookupTest, "hello")

Task.async(fn ->
  Registry.lookup(Registry.UniqueLookupTest, "hello")
end) |> Task.await()
