Todo.System.start_link()
Process.exit(Process.whereis(Todo.Database), :kill)
Process.exit(Process.whereis(Todo.Cache), :kill)

{:ok, _} = Registry.start_link(name: :my_registry, keys: :unique)

# Register this one off process to the registry relying on the fact that this
# automatically puts the pid of the registering party in the registry along with
# a value (which we don't care about here)
spawn(fn ->
  Registry.register(:my_registry, {:database_worker, 1}, nil)

  receive do
    msg -> IO.puts("got message #{inspect(msg)}")
  end
end)

# Do the registry lookup (we're in the role of "client" here), again we dont
# care about the value, which is nil from the registering that happened above
[{db_worker_pid, _value}] = Registry.lookup( :my_registry, {:database_worker, 1})


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

# EchoServer
defmodule EchoServer do
  use GenServer

  def start_link(id) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(id))
  end

  def call(id, some_request) do
    IO.inspect(via_tuple(id))
    GenServer.call(via_tuple(id), some_request)
  end

  defp via_tuple(id) do
    {:via, Registry, {:my_registry, {__MODULE__, id}}}
  end

  def handle_call(some_request, _, state) do
    IO.inspect(self())
    {:reply, some_request, state}
  end
end

Registry.start_link(name: :my_registry, keys: :unique)

EchoServer.start_link("server one")
EchoServer.start_link("server two")

EchoServer.call("server one", :some_request)
EchoServer.call("server two", :another_request)

# Supervising each worker
Todo.System.start_link()

[{worker_pid, _}] =
  Registry.lookup(
    Todo.ProcessRegistry,
    {Todo.DatabaseWorker, 2}
  )

Process.exit(worker_pid, :kill)
