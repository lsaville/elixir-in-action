try_helper = fn fun ->
  try do
    fun.()
    IO.puts("No error.")
  catch type, value ->
    IO.puts("Error\n #{inspect(type)}\n #{inspect(value)}")
  end
end

try_helper.(fn -> raise("something went wrong") end)

try_helper.(fn -> :erlang.error("something went wrong") end)

try_helper.(fn -> throw("thrown value") end)
try_helper.(fn -> exit("I'm done") end)

result =
  try do
    throw("Thrown value")
  catch type, value -> {type, value}
  end

try do
  raise("something went wrong")
catch
  _,_ -> IO.puts("error caught")
after
  IO.puts("cleanup code")
end

spawn(fn ->
  spawn(fn ->
    Process.sleep(5000)
    IO.puts("process 2, #{inspect self()}, finished")
  end)

  IO.puts("process 1, #{inspect self()} about to have something go wrong")
  raise("something went wrong")
end)

spawn(fn ->
  spawn_link(fn ->
    Process.sleep(5000)
    IO.puts("process 2, #{inspect self()}, finished")
  end)

  IO.puts("process 1, #{inspect self()} about to have something go wrong")
  raise("something went wrong")
end)

spawn(fn ->
  Process.flag(:trap_exit, true)

  spawn_link(fn -> raise("something went wrong") end)

  receive do
    msg -> IO.inspect(msg)
  end
end)
